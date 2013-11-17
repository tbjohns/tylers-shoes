require "rubygems"
require "./shoes"
require "./twitterface"

tweet = Shoes.get_tweet()
Twitterface.send_tweet(tweet) if tweet

