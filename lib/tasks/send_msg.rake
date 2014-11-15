namespace :send_msg do
  desc "アカウントtasquelを使って、メッセージを自動ツイート"
  task :first_notification => :environment do
    #Twitter設定：環境変数から値を読み込む
    tw_client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TW_APPID"]
      config.consumer_secret = ENV["TW_SECRET"]
      config.oauth_token = ENV["TW_ATOKEN"]
      config.oauth_token_secret = ENV["TW_ASECRET"]
    end
    
    #発言
    dest_account = "YoshikiEguchi" 
    tw_client.update("@#{dest_account} 薬飲みましたか？")
  end
  
end
