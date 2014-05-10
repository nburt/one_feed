[![Build Status](https://travis-ci.org/nburt/one_feed.svg?branch=master)](https://travis-ci.org/nburt/one_feed)
[![Code Climate](https://codeclimate.com/github/nburt/one_feed.png)](https://codeclimate.com/github/nburt/one_feed)

OneFeed is an app that allows registered users to link their social media accounts together into one feed.

### Links

1. Tracker Project URL: https://www.pivotaltracker.com/n/projects/1071248
1. Heroku staging url: http://one-feed-staging.herokuapp.com

### Initial Setup

1. Change scripts/create_databases.sql to create both your development and test databases.
1. Create a `.env` file and add your apps API keys and API secrets. You will need to register your app for each social media site.

Here is an example for Twitter:

TWITTER_API_KEY=\<your Twitter app's API key\>  
TWITTER_API_SECRET=\<your Twitter app's API secret\>

The `.env` is ignored by git, see the `.gitignore` file.

### Development

1. `bundle install`
1. Create a database by running `psql -d postgres -f scripts/create_databases.sql`
1. Run migrations using `rake db:migrate` and `RAILS_ENV=test rake db:migrate`
1. Run tests using `rspec` or `rake spec`
