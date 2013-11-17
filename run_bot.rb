require "rubygems"
require_relative "shoes"
require_relative "twitterface"

tweet = Shoes.get_tweet()
Twitterface.send_tweet(tweet) if tweet

