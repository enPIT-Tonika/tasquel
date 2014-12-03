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
   
    jst = 60 * 60 * 9 #UTCからの日本時間のoffset
    dest_accounts = User.where(notify: true) 
    t = Time.now #現在時刻の取得
    tt = t.hour * 60 + t.min #0時からの経過分数を取り出し 
    dest_accounts.each do |dest_account|
      p "#{dest_account.screen_name} :"
      begin
        next if dest_account.json_time.blank?
 
        json_time = dest_account.json_time
        #通知する時間かを確認する
        json_time.each_with_index do |j, idx|
           if j["extend"]  && !j["extended_time"].blank?
            i = Time.parse(j["extended_time"]) - jst
            j["extend"] = false #再通知はリセット
            j["extend_time"] = nil #時間も消しておく
          else
            i = Time.parse(j["time"]) - jst
          end
          n = i.hour * 60 + i.min #0時からの経過分数を取り出し 
          p "current_time: #{n}"
          p "projected time: #{tt}"
          if (tt + 5) >= n && n >= (tt - 5)
            p "tyring to tweet for #{dest_account.screen_name}"
            url = create_reinform_link(i, idx, dest_account.id)
            p "url: #{url}"
            msg = create_msg(dest_account.screen_name, j["desc"], url)
            tw_client.update(msg)
            break
          end
        end
        dest_account.update({json_time: json_time}) #json_timeをアップデート
      rescue => e
        Rails.logger.error"<<rake send_msg:first_notification ERROR : #{e.message}>>"
      end
     end
    end
    
    desc "薬が少なくなると通知する。（@tasquelからツイート)"
    task :go_to_hospital => :environment do |task|
        p "executing rake send_msg:go_to_hospital"
        tw_client = Twitter::REST::Client.new do |config|
          config.consumer_key = ENV["TW_APPID"]
          config.consumer_secret = ENV["TW_SECRET"]
          config.access_token = ENV["TW_ATOKEN"]
          config.access_token_secret = ENV["TW_ASECRET"]
        end
        
        dest_accounts = User.all
        dest_accounts.each do |dest_account|
           p "#{dest_account.screen_name} :"
           next if dest_account.medicine_num.blank?
           num = dest_account.medicine_num
           num -= 1 if num > 0 #残り日数を-1
           begin
             dest_account.update_attributes({medicine_num: num}) #日数をアップデート
             next if dest_account.notify == false
             if num < 8 #日数を確認
              p "tyring to tweet for #{dest_account.screen_name}"
              msg = create_go_hosp_msg(dest_account.screen_name,num)
              tw_client.update(msg) 
            end
          rescue => e
              Rails.logger.error"<<rake send_msg:go_to_hospital ERROR : #{e.message}>>"
          end 
        end 
    end
    
    #発言をランダムに作成
    def create_msg(account, desc=nil, url=nil)
      if desc == nil
        desc = "薬の時間"
      else
        desc += "の薬の時間"
      end
      r = Random.new_seed % 2 #乱数で0か1かを得る
      comment = "@#{account} #{desc}"
      if r == 0
        comment += "だよ！薬飲んだ？ by カプ君　あとで再通知してほしかったら→#{url} "
      else
        comment += "だぞ！薬の時間だ！飲まないとやばいぞ！ by タブ君　あとで再通知してほしけりゃ→#{url}"
      end
      return comment      
    end
    
    #病院へ行くことを促す発言をランダムに作成
    def create_go_hosp_msg(account, num)
      r = Random.new_seed % 2 #乱数で0か1かを得る
      comment = "@#{account} "
      if num < 1
        comment += "もう薬がない"
      else
        comment += "あと#{num}日で薬がなくなる"
      end
      if r == 0
        comment += "よ！病院に行ってね！お薬手帳も忘れずに！ by カプ君"
      else
        comment += "ぞ！病院に行けよ！お薬手帳も持ってくんだぞ！ by タブ君"
      end
      return comment      
    end
    
    def create_reinform_link(t, idx, id)
      #再通知のためのリンクを生成する
      reinform_min = 30 #再通知する分数
      jst = 60 * 60 * 9
      t = t + (60*reinform_min) + jst
      h = sprintf("%2d", t.hour)
      m = sprintf("%2d", t.min)
      url = "http://tasquel.heroku.com/" #本番用url
      if Rails.env == 'development'
        #開発環境なら、urlをローカルホストにする
        url = "http://127.0.0.1:3000/"
        #url = "http://tasquel.heroku.com/"
      end
      #urlの残り部分をセット
      url += "extend/#{id}?idx=#{idx}&hour=#{h}&min=#{m}"
      bitly_url = shorten(url)
      return bitly_url
    end
    
    def shorten(url)
      Bitly.use_api_version_3
      Bitly.configure do |config|
        config.api_version = 3
        config.access_token = ENV["BITLY_TOKEN"]
      end
      b = Bitly.client.shorten(url)
      return b.short_url
    end
end
