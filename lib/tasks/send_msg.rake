require 'twitter'

namespace :send_msg do
  desc "アカウントtasquelを使って、メッセージを自動ツイート"  
  task :first_notification => :environment  do |task|
     #Twitter設定：環境変数から値を読み込む
    tw_client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TW_APPID"]
      config.consumer_secret = ENV["TW_SECRET"]
      config.access_token = ENV["TW_ATOKEN"]
      config.access_token_secret = ENV["TW_ASECRET"]
    end
   
    jst = (60 * 60 * 24) - (60*60*9) #UTCからの日本時間のoffset
    dest_accounts = User.where(notify: true) 
    t = Time.now #現在時刻の取得
    dest_accounts.each do |dest_account|
      begin
        #json_timeが空の場合は朝８時、夜８時につぶやくようデータをセット
        # (時刻はUTCでセット)
        if dest_account.json_time.blank?
          json_time = [
            {
              desc: "朝食後",
              time: "8:00"
            },
            {
              desc: "夕食後",
              time: "20:00"
            }
          ]
          else
            json_time = dest_account.json_time
          end
          #通知する時間かを確認する
          json_time.each do |j|
            i = Time.parse(j["time"]) + jst
            p i
            p t
            if t+300 >= i && i >= t-300
              p "tyring to tweet..."
              msg = create_msg(dest_account.screen_name, j["desc"])
              p msg
              tw_client.update(msg)
              break
            end
          end
        rescue => e
          Rails.logger.error"<<twitter.rake::tweet.update ERROR : #{e.message}>>"
        end
      end
    end
    
    #発言をランダムに作成
    def create_msg(account, desc)
      if desc == nil
        desc = "薬の時間"
      else
        desc += "の薬の時間"
      end
      r = Random.new_seed % 2 #乱数で0か1かを得る
      comment = "@#{account} #{desc}"
      if r == 0
        comment += "だよ！薬飲んだ？ by カプ君"
      else
        comment += "だぞ！薬の時間だ！飲まないとやばいぞ！ by タブ君"
      end     
      return comment      
    end
end

    
    