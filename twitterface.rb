require "rubygems"
require "twitter"
require "yaml"

module Twitterface 

  creds_path = File.expand_path("../config/twitter_creds.yml", __FILE__)
  twitter_creds = YAML.load_file(creds_path)

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

