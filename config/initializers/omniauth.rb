Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
  provider :facebook, '247405602033317', '1fb20b6cfbe394420985b3c43bb827ab'
end