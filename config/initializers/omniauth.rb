Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, APP_CONFIG['facebook']['app_id'] || ENV['FACEBOOK_KEY'], APP_CONFIG['facebook']['app_secret'] || ENV['FACEBOOK_SECRET'], scope: 'publish_stream,email'
end
