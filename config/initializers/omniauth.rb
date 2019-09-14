#Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :facebook,ENV['FACEBOOK_KEY'],ENV['FACEBOOK_SECRET']
#  provider :google_oauth2,ENV['GOOGLE_CLIENT_ID'],ENV['GOOGLE_CLIENT_SECRET'],{:skip_jwt =>true}

  #{:provider_ignores_state => true}
#end
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.secrets.google_client_id, Rails.application.secrets.google_client_secret
end
