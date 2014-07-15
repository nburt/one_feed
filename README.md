[![Build Status](https://travis-ci.org/nburt/one_feed.svg?branch=master)](https://travis-ci.org/nburt/one_feed)
[![Code Climate](https://codeclimate.com/github/nburt/one_feed.png)](https://codeclimate.com/github/nburt/one_feed)

OneFeed is a social media aggregator that allows users to stream multiple social media accounts and post back to them.

### Initial Setup

1. Change scripts/create_databases.sql to create both your development and test databases.
1. Create a `.env` file and add your apps API keys and API secrets. You will need to register your app for each social media site. See the `.env.example` file.

You will also need to add a SendGrid username and password to your production environment variables in order to send emails. This will look something like this:

```
SENDGRID_PASSWORD:<YOUR SENDGRID PASSWORD>
SENDGRID_USERNAME:<YOUR SENDGRID USERNAME>
```

### Development

1. `bundle install`
1. Create the databases by running `psql -d postgres -f scripts/create_databases.sql`
1. Run migrations using `rake db:migrate` and `RAILS_ENV=test rake db:migrate`
1. Run Ruby tests using `rspec` or `rake spec`
1. Run Javascript tests using `rake jasmine` and opening your browser to localhost:8888
