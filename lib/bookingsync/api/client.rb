require "bookingsync/api/middleware/authentication"
require "bookingsync/api/client/bookings"
require "bookingsync/api/client/rentals"
require "bookingsync/api/error"

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
    # @param options [Hash] Query params for the request
    # @return [Array<Sawyer::Resource>] Array of resources.
    def get(path, options = {})
      request :get, path, query: options
    end

    # Make a HTTP POST request
    #
    # @param path [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body params for the request
    # @return [Array<Sawyer::Resource>]
    def post(path, options = {})
      request :post, path, options
    end

    # Make a HTTP PUT request
    #
    # @param path [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body params for the request
    # @return [Array<Sawyer::Resource>]
    def put(path, options = {})
      request :put, path, options
    end

    # Make a HTTP DELETE request
    #
    # @param path [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body params for the request
    # @return [Array<Sawyer::Resource>]
    def delete(path, options = {})
      request :delete, path, options
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
    # @param method [Symbol] HTTP verb to use.
    # @param path [String] The path, relative to {#api_endpoint}.
    # @param data [Hash] Data to be send in the request's body
    #   it can include query: key with requests params for GET requests
    # @param options [Hash] A customizable set of request options.
    # @return [Array<Sawyer::Resource>] Array of resources.
    def request(method, path, data, options = {})
      if data.is_a?(Hash)
        options[:query] = data.delete(:query) || {}
        [:fields, :status].each do |key|
          if options[:query].has_key?(key)
            options[:query][key] = Array(options[:query][key]).join(",")
          end
        end
      end

      response = agent.call(method, path, data.to_json, options)
      case response.status
      when 204; [] # update/destroy response
        # fetch objects from outer hash
        # {rentals => [{rental}, {rental}]}
        # will return [{rental}, {rental}]
      when 200..299; response.data.to_hash.values.flatten
      when 401; raise Unauthorized.new
      when 422; raise UnprocessableEntity.new
      end
    end

    private

    def agent
      @agent ||= Sawyer::Agent.new(api_endpoint, sawyer_options) do |http|
        http.headers[:accept] = MEDIA_TYPE
        http.headers[:content_type] = MEDIA_TYPE
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
