require "rubygems"
require "twitter"
require "yaml"

token_hash = YAML.load_file("config/twitter_auth.yml")

client = Twitter.configure do |config|
	config.consumer_key = token_hash[:consumer_key]
	config.consumer_secret = token_hash[:consumer_secret]
	config.oauth_token = token_hash[:oauth_token]
	config.oauth_token_secret = token_hash[:oauth_token_secret]
end

Twitter.update("I'm still tweetin with ruby.")

