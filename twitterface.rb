require "rubygems"
require "twitter"
require "yaml"

module Twitterface 

	twitter_creds = YAML.load_file("config/twitter_creds.yml")

	client = Twitter.configure do |config|
		config.consumer_key = twitter_creds[:consumer_key]
		config.consumer_secret = twitter_creds[:consumer_secret]
		config.oauth_token = twitter_creds[:oauth_token]
		config.oauth_token_secret = twitter_creds[:oauth_token_secret]
	end

	def Twitterface.send_tweet(tweet)
		Twitter.update(tweet)
	end

end

