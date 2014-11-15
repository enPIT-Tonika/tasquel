require 'twitter'

namespace :send_msg do
  desc "アカウントtasquelを使って、メッセージを自動ツイート"
  task :hage, ['hige', 'hege'] => :environment do |task, args|
    puts args.hige
    puts args.hege
  end
  
  task :first_notification,['info'] => :environment  do |task, args|
     #Twitter設定：環境変数から値を読み込む
    tw_client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TW_APPID"]
      config.consumer_secret = ENV["TW_SECRET"]
      config.access_token = ENV["TW_ATOKEN"]
      config.access_token_secret = ENV["TW_ASECRET"]
    end
    
    #発言
    dest_account = "YoshikiEguchi" 
    begin
      tw_client.update("@#{dest_account}  #{args.info}です。薬飲みましたか？")
    rescue => e
      Rails.logger.error "<<twitter.rake::tweet.update ERROR : #{e.message}>>"
    end
   
  end
  
end