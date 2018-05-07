#!/usr/bin/env ruby

require 'twitter'
require 'dotenv'
require 'pushover'
require 'logger'

Dotenv.load
$logger = Logger.new(STDOUT)
WATCH_LIST = ENV.fetch("WATCH_LIST")

config = {
  consumer_key:        ENV.fetch("TWITTER_API_KEY"),
  consumer_secret:     ENV.fetch("TWITTER_API_SECRET"),
  access_token:        ENV.fetch("TWITTER_ACCESS_TOKEN"),
  access_token_secret: ENV.fetch("TWITTER_ACCESS_SECRET")
}
stream_client = Twitter::Streaming::Client.new(config)
rest_client = Twitter::REST::Client.new(config)

def push_notification(tweet)
  $logger.info "#{tweet.user.screen_name}: #{tweet.full_text}"
  pushover_client = Pushover.notification(
    message: tweet.full_text,
    title: "An update from #{tweet.user.screen_name}",
    url: tweet.url,
    user: ENV.fetch("PUSHOVER_USER_TOKEN"),
    token: ENV.fetch("PUSHOVER_APP_TOKEN"),
  )
end

# Monkey-patch the Twitter gem to pull 140+ character tweets instead of the truncated version.
class Twitter::Tweet
  def full_text
    attrs[:extended_tweet][:full_text]
  end
end

watch_list_ids = rest_client.list_members(WATCH_LIST).attrs[:users].map{ |user| user[:id].to_s }.join(",")
stream_client.filter(follow: watch_list_ids, tweet_mode: "extended") do |object|
  case object
  when Twitter::Tweet
    push_notification(object)
  when Twitter::DirectMessage
    puts "It's a direct message!"
    p object
  when Twitter::Streaming::StallWarning
    warn "Falling behind!"
  when Twitter::Streaming::DeletedTweet
    puts "Twitter::Streaming::DeletedTweet"
    p object
  when Twitter::Streaming::Event
    puts "Twitter::Streaming::Event"
    p object
  when Twitter::Streaming::FriendList
    puts "Twitter::Streaming::FriendList"
  end
end
