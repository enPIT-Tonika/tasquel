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
   
    jst = (60 * 60 * 9) #UTCからの日本時間のoffset
    dest_accounts = User.where(notify: true) 
    t = Time.now #現在時刻の取得
    tt = t.hour * 60 + t.min #0時からの経過分数を取り出し 
    dest_accounts.each do |dest_account|
      begin
        next if dest_account.json_time.blank?
 
        json_time = dest_account.json_time
        #通知する時間かを確認する
        json_time.each do |j|
          i = Time.parse(j["time"]) - jst
          j = i.hour * 60 + i.min #0時からの経過分数を取り出し 
          p j
          p tt
          if tt + 3 >= j && j >= tt - 3
            p "tyring to tweet for #{dest_account.screen_name}"
            msg = create_msg(dest_account.screen_name, j["desc"])
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