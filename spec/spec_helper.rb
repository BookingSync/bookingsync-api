$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "bookingsync/api"
require "webmock/rspec"
require "vcr"
require "json"
require "pry"

RSpec.configure do |config|
  config.before do
    ENV["BOOKINGSYNC_VERIFY_SSL"] = "false"
  end
  config.include WebMock::API
end

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/cassettes"
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data("<<ACCESS_TOKEN>>") do
    test_access_token
  end
  c.default_cassette_options = { match_requests_on: [:method, :path] }
end

def test_access_token
  ENV.fetch "ACCESS_TOKEN", "fake-access-token"
end

def bs_url(path = "")
  # so that it works when running against local BS API
  url = ENV["BOOKINGSYNC_URL"] || "https://www.bookingsync.com"
  "#{url}/api/v3/#{path}"
end

def stub_get(path, options = {})
  response = {
    body: {}.to_json,
    headers: { "Content-Type" => "application/vnd.api+json" }
  }.merge(options)
  stub_request(:get, bs_url(path)).to_return(response)
end

def stub_post(path, options = {})
  response = {
    body: {}.to_json,
    headers: { "Content-Type" => "application/vnd.api+json" }
  }.merge(options)
  stub_request(:post, bs_url(path)).to_return(response)
end

def stub_put(path, options = {})
  response = {
    body: {}.to_json,
    headers: { "Content-Type" => "application/vnd.api+json" }
  }.merge(options)
  stub_request(:put, bs_url(path)).to_return(response)
end

def stub_delete(path, options = {})
  response = {
    body: {}.to_json,
    headers: { "Content-Type" => "application/vnd.api+json" }
  }.merge(options)
  stub_request(:delete, bs_url(path)).to_return(response)
end
