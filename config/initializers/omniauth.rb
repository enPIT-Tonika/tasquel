Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :twitter, Settings.twitter.consumer_key, Settings.twitter.consumer_secret, :callback_path => '/callback'
  provider :twitter, Settings.twitter.consumer_key, Settings.twitter.consumer_secret
end

#OmniAuth.config.on_failure = Proc.new { |env|
#  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
#}
