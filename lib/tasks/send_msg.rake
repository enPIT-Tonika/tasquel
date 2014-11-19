require 'twitter'

namespace :send_msg do
  desc "アカウントtasquelを使って、メッセージを自動ツイート"  
  task :first_notification,['info'] => :environment  do |task, args|
     #Twitter設定：環境変数から値を読み込む
    tw_client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TW_APPID"]
      config.consumer_secret = ENV["TW_SECRET"]
      config.access_token = ENV["TW_ATOKEN"]
      config.access_token_secret = ENV["TW_ASECRET"]
    end
    
    #発言
    r = Random.new_seed % 2 #乱数で0か1かを得る
    dest_accounts = User.where(notify: true)
    comment = ""
    if r == 0
      comment = "だよ！薬飲んだ？ by カプ君"
    else
      comment = "だぞ！薬飲まないとやばいぞ！ by タブ君"
    end
    
    dest_accounts.each do |dest_account| 
      begin
        tw_client.update("@#{dest_account.screen_name}  #{args.info}#{comment}")
      rescue => e
        Rails.logger.error "<<twitter.rake::tweet.update ERROR : #{e.message}>>"
      end
    end
  end
  
end
