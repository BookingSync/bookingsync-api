[![Build Status](https://travis-ci.org/BookingSync/bookingsync-api.png?branch=master)](https://travis-ci.org/BookingSync/bookingsync-api)
[![Code Climate](https://codeclimate.com/github/BookingSync/bookingsync-api.png)](https://codeclimate.com/github/BookingSync/bookingsync-api)

# BookingSync::API

This gem allows Ruby developers to programmatically access https://www.bookingsync.com

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bookingsync-api'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install bookingsync-api
```

## Usage

Gem assumes that you already have OAuth token for an account.

```ruby
api = BookingSync::API.new("OAUTH_TOKEN")
rentals = api.rentals # => [BookingSync::API::Resource, BookingSync::API::Resource]
rentals.first.name # => "Small apartment"
```

### Pagination

All endpoints returning a collection of resources can be paginated. There are three ways to do it.

Specify `:per_page` and `:page` params. It's useful when implementing pagination on your site.

```ruby
api.bookings(per_page: 10, page: 1) => [BookingSync::API::Resource, BookingSync::API::Resource, ...]
```

Use pagination with a block.

```ruby
api.bookings(per_page: 10) do |batch|
  # display 10 bookings, will make one HTTP request for each batch
end
```

Fetch all resources (with multiple requests under the hood) and return one big array.

```ruby
api.bookings(auto_paginate: true) => [BookingSync::API::Resource, BookingSync::API::Resource, ...]
```

### Meta information

Some endpoints return additional info about resource in meta section. To fetch it you need to
access last response.

```ruby
api.rentals(updated_since: "2014-01-01 15:43:96 UTC") # => [BookingSync::API::Resource,    BookingSync::API::Resource, ...]
api.last_response.meta # => {"deleted_ids" => [1, 3, 4]}
```

### Logging

Sometimes it's useful to see what data bookingsync-api gem sends and what it
receives from the API. By default, gem doesn't log anything.
There are two ways to enable logging:

1. Set `BOOKINGSYNC_API_DEBUG` environment variable to `true`, when running
  gem or your app server in development. This will print all logs to `STDOUT`.

2. Pass your own logger to API client, it can be for example `Rails.logger`.

  ```ruby
  api = BookingSync::API.new("OAUTH_TOKEN", logger: Rails.logger)
  ```

### Instrumentation

BookingSync::API exposes instrumentation information that can be consumed
by various instrumentation libraries. By default it doesn't send the
information anywhere.

To hook instrumentations into `ActiveSupport::Notifications`, pass the
module into the API client initializer:

```ruby
api = BookingSync::API.new("OAUTH_TOKEN", instrumenter: ActiveSupport::Notifications)
```

#### Log levels

`INFO` - Logged are only request method and the URL.
`DEBUG` - Logged are request and response headers and bodies.

When using `BOOKINGSYNC_API_DEBUG` variable, log level is DEBUG.

## Gem documentation

See [gem documentation](http://rdoc.info/github/BookingSync/bookingsync-api/master/frames) for more info.

## API documentation

See [API documentation](http://developers.bookingsync.com).

## Running specs

```
bundle exec rspec
```

OR

```
bundle exec guard
```

### Recording VCR cassettes

For developing bookingsync-api gem you need OAuth access token. In order to record a cassette,
you need to run spec with below environment variables.

```
ACCESS_TOKEN=abc bundle exec rspec
```

If you want to change a cassette, you need to delete it first.

### Environment variables

There are a few environment variables which comes handy while developing and
debugging bookingsync-api gem.

* `BOOKINGSYNC_URL` - The url of the website, should be. Default https://www.bookingsync.com
* `BOOKINGSYNC_VERIFY_SSL` - Verify SSL. Default to true.
* `BOOKINGSYNC_API_DEBUG` - If true, gem will log all request/responses to STDOUT. Default to false.
* `ACCESS_TOKEN` - OAuth token.

## Contributing

1. Fork it ( http://github.com/BookingSync/bookingsync-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
