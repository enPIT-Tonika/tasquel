# Be sure to restart your server when you modify this file.

#Twitter設定：環境変数から値を読み込む
$tw_client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV["TW_APPID"]
  config.consumer_secret = ENV["TW_SECRET"]
  config.access_token = ENV["TW_ATOKEN"]
  config.access_token_secret = ENV["TW_ASECRET"]
end