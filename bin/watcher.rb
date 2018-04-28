#!/usr/bin/env ruby

require 'twitter'
require 'dotenv'
require 'pushover'

Dotenv.load

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV.fetch("TWITTER_API_KEY")
  config.consumer_secret     = ENV.fetch("TWITTER_API_SECRET")
  config.access_token        = ENV.fetch("TWITTER_ACCESS_TOKEN")
  config.access_token_secret = ENV.fetch("TWITTER_ACCESS_SECRET")
end

def push_notification(tweet)
  puts "#{tweet.user.screen_name}: #{tweet.full_text}"
  pushover_client = Pushover.notification(
    message: tweet.full_text,
    title: "An update from #{tweet.user.screen_name}",
    url: tweet.url,
    user: ENV.fetch("PUSHOVER_USER_TOKEN"),
    token: ENV.fetch("PUSHOVER_APP_TOKEN"),
  )
end

$seen_ids = Set.new
# tweets = client.user_timeline("ATLAirport")
# require 'pry'; binding.pry

while 1
  ENV.fetch("WATCHED_USERS").split(",").each do |user|
    client.user_timeline(user).take(5).each do |tweet|
      next if tweet.reply?
      next if $seen_ids.include? tweet.id

      $seen_ids << tweet.id
      push_notification(tweet)
    end
  end

  sleep 5
end
