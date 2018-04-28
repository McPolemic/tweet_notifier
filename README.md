# Tweet::Notifier

Watch Twitter from a server, sending push notifications to a phone when certain users post.

## Usage

1. Clone the repo.
2. `bundle install`
3. `cp .env.example .env`
4. Update `.env` with API keys for Twitter and Pushover, possibly modify the list of users to watch.
5. `bundle exec ruby bin/watcher.rb`

## Story

In December of 2017, my wife and I were traveling internarionally and waiting for our flight to go back to the states. Unfortunately, the flight home was delayed, and delayed, and delayed. We learned there were [problems][atl] at Atlanta International Airport and it wasn't entirely clear when they'd be resolved.

Getting new information during this was difficult. Hotel wifi is never very reliable and international roaming data is expensive. I wanted to stop regularly checking sites and start having news pushed to us when it was happening.

Luckily, push notifications use very little data and notify people when there's new information. While waiting for the flight, I made this quick script to check a number of news account and Atlanta International's twitter feed for new posts. It then uses Pushover to send push notifications.

We ended up trapped in paradise for two more days, but it was relatively easy to track the repairs and when the airport would be available again because of this script.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

