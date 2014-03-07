require "bookingsync/api/middleware/authentication"
require "bookingsync/api/client/bookings"
require "bookingsync/api/client/rentals"

module BookingSync::API
  class Client
    include BookingSync::API::Client::Bookings
    include BookingSync::API::Client::Rentals

    MEDIA_TYPE = "application/vnd.api+json"

    attr_reader :token

    # Initialize new Client
    #
    # @param token [String] OAuth token
    # @return [BookingSync::API::Client] New BookingSync API client
    def initialize(token)
      @token = token
    end

    # Make a HTTP GET request
    #
    # @param path [String] The path, relative to {#api_endpoint}
    # @return [Array<Sawyer::Resource>] Array of resources.
    def get(path)
      request :get, path
    end

    # Return API endpoint
    #
    # @return [String] URL to API endpoint
    def api_endpoint
      "#{base_url}/api/v3"
    end

    protected

    # Make a HTTP request to given path
    #
    # @param method [Symbol] HTTP verb to use
    # @param path [String] The path, relative to {#api_endpoint}
    # @return [Array<Sawyer::Resource>] Array of resources.
    def request(method, path)
      response = agent.call(method, path)
      if (200..299).include?(response.status)
        # fetch objects from outer hash
        # {rentals => [{rental}, {rental}]}
        # will return [{rental}, {rental}]
        response.data.to_hash.values.flatten
      end
    end

    private

    def agent
      @agent ||= Sawyer::Agent.new(api_endpoint, sawyer_options) do |http|
        http.headers[:accept] = MEDIA_TYPE
      end
    end

    def middleware
      Faraday::RackBuilder.new do |builder|
        builder.use :authentication, token
        builder.adapter Faraday.default_adapter
      end
    end

    def sawyer_options
      {faraday: Faraday.new(faraday_options)}
    end

    def faraday_options
      {builder: middleware, ssl: {verify: verify_ssl?}}
    end

    # Return BookingSync base URL. Default is https://www.bookingsync.com
    # it can be altered via ENV variable BOOKINGSYNC_URL which
    # is useful in specs when recording vcr cassettes
    #
    # @return [String] Base URL to BookingSync
    def base_url
      ENV.fetch "BOOKINGSYNC_URL", "https://www.bookingsync.com"
    end

    # Return true if SSL cert should be verified
    # By default is true, can be changed to false using
    # env variable VERIFY_SSL
    #
    # @return [Boolean] true if SSL needs to be verified
    # false otherwise
    def verify_ssl?
      ENV["BOOKINGSYNC_VERIFY_SSL"] == "false" ? false : true
    end
  end
end
