[![Build Status](https://travis-ci.org/BookingSync/bookingsync-api.png?branch=master)](https://travis-ci.org/BookingSync/bookingsync-api)
[![Code Climate](https://codeclimate.com/github/BookingSync/bookingsync-api.png)](https://codeclimate.com/github/BookingSync/bookingsync-api)

# BookingSync::API

This gem allows Ruby developers to programmatically access https://www.bookingsync.com

## Installation

Add this line to your application's Gemfile:

    gem 'bookingsync-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bookingsync-api

## Usage

Gem assumes that you already have OAuth token for an account.

    api = BookingSync::API.new("OAUTH_TOKEN")
    rentals = api.rentals # => [Sawyer::Resource, Sawyer::Resource]
    rentals.first.name # => "Small apartment"

See our [documentation](http://rubydoc.info/github/BookingSync/bookingsync-api) for more info.

## Running specs

    bundle exec rspec

OR

    bundle exec guard


## Contributing

1. Fork it ( http://github.com/BookingSync/bookingsync-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
