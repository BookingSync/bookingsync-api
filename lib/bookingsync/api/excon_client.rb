require "bookingsync/api/middleware/logger"
require "bookingsync/api/client/accounts"
require "bookingsync/api/client/amenities"
require "bookingsync/api/client/availabilities"
require "bookingsync/api/client/bathrooms"
require "bookingsync/api/client/bedrooms"
require "bookingsync/api/client/bookings"
require "bookingsync/api/client/bookings_fees"
require "bookingsync/api/client/bookings_payments"
require "bookingsync/api/client/bookings_taxes"
require "bookingsync/api/client/clients"
require "bookingsync/api/client/destinations"
require "bookingsync/api/client/fees"
require "bookingsync/api/client/inquiries"
require "bookingsync/api/client/instant_bookings"
require "bookingsync/api/client/periods"
require "bookingsync/api/client/payments"
require "bookingsync/api/client/photos"
require "bookingsync/api/client/rates"
require "bookingsync/api/client/rates_rules"
require "bookingsync/api/client/rates_tables"
require "bookingsync/api/client/rentals"
require "bookingsync/api/client/rentals_fees"
require "bookingsync/api/client/rentals_amenities"
require "bookingsync/api/client/rental_agreements"
require "bookingsync/api/client/reviews"
require "bookingsync/api/client/seasons"
require "bookingsync/api/client/special_offers"
require "bookingsync/api/client/sources"
require "bookingsync/api/client/taxes"
require "bookingsync/api/error"
require "bookingsync/api/relation"
require "bookingsync/api/excon_response"
require "bookingsync/api/resource"
require "bookingsync/api/serializer"
require "logger"
require "addressable/template"
require "excon"

module BookingSync::API
  class ExconClient
    extend Forwardable
    include BookingSync::API::Client::Accounts
    include BookingSync::API::Client::Amenities
    include BookingSync::API::Client::Availabilities
    include BookingSync::API::Client::Bathrooms
    include BookingSync::API::Client::Bedrooms
    include BookingSync::API::Client::Bookings
    include BookingSync::API::Client::BookingsFees
    include BookingSync::API::Client::BookingsPayments
    include BookingSync::API::Client::BookingsTaxes
    include BookingSync::API::Client::Clients
    include BookingSync::API::Client::Destinations
    include BookingSync::API::Client::Fees
    include BookingSync::API::Client::Inquiries
    include BookingSync::API::Client::InstantBookings
    include BookingSync::API::Client::Periods
    include BookingSync::API::Client::Payments
    include BookingSync::API::Client::Photos
    include BookingSync::API::Client::Rates
    include BookingSync::API::Client::RatesRules
    include BookingSync::API::Client::RatesTables
    include BookingSync::API::Client::Rentals
    include BookingSync::API::Client::RentalsFees
    include BookingSync::API::Client::RentalsAmenities
    include BookingSync::API::Client::RentalAgreements
    include BookingSync::API::Client::Reviews
    include BookingSync::API::Client::Seasons
    include BookingSync::API::Client::SpecialOffers
    include BookingSync::API::Client::Sources
    include BookingSync::API::Client::Taxes

    MEDIA_TYPE = "application/vnd.api+json"
    CONNECT_TIMEOUT = 5

    attr_reader :token, :logger, :last_response

    def_delegator :@instrumenter, :instrument

    # Initialize new Client
    #
    # @param token [String] OAuth token
    # @param options [Hash]
    # @option options [String] base_url: Base URL to BookingSync site
    # @option options [Logger] logger: Logger where headers and body of every
    #   request and response will be logged.
    # @option options [Module] instrumenter: A module that responds to
    #   instrument, usually ActiveSupport::Notifications.
    # @return [BookingSync::API::Client] New BookingSync API client
    def initialize(token, options = {})
      @token = token
      @logger = options[:logger] || default_logger
      @instrumenter = options[:instrumenter] || NoopInstrumenter
      @base_url = options[:base_url]
      @persistent = options[:persistent]
      @serializer = Serializer.new
      @conn = Excon.new(base_url, excon_options)
      # @conn = Faraday.new(faraday_options)
      # @conn.headers[:accept] = MEDIA_TYPE
      # @conn.headers[:content_type] = MEDIA_TYPE
      # @conn.headers[:user_agent] = user_agent
      # @conn.url_prefix = api_endpoint
      yield @conn if block_given?
    end

    def excon_options
      {
        headers: {
          "Accept" => MEDIA_TYPE,
          "Content-Type" => MEDIA_TYPE,
          "User-Agent" => user_agent
        },
        tcp_nodelay: true,
        connect_timeout: CONNECT_TIMEOUT,
        instrumentor: @instrumenter,
        persistent: @persistent,
        ssl_verify_peer: verify_ssl?
      }
    end

    # Make a HTTP GET request
    #
    # @param path [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query params for the request
    # @return [Array<BookingSync::API::Resource>] Array of resources.
    def get(path, options = {})
      request :get, path, query: options
    end

    # Make a HTTP POST request
    #
    # @param path [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body params for the request
    # @return [Array<BookingSync::API::Resource>]
    def post(path, options = {})
      request :post, path, options
    end

    # Make a HTTP PUT request
    #
    # @param path [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body params for the request
    # @return [Array<BookingSync::API::Resource>]
    def put(path, options = {})
      request :put, path, options
    end

    # Make a HTTP DELETE request
    #
    # @param path [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body params for the request
    # @return [Array<BookingSync::API::Resource>]
    def delete(path, options = {})
      request :delete, path, options
    end

    # Return API endpoint
    #
    # @return [String] URL to API endpoint
    def api_endpoint
      URI.join(base_url, "api/v3").to_s
    end

    # Encode an object to a string for the API request.
    #
    # @param data [Object] The Hash or Resource that is being sent.
    # @return [String] Object encoded into JSON string
    def encode_body(data)
      @serializer.encode(data)
    end

    # Decode a String response body to a Resource.
    #
    # @param str [String] The String body from the response.
    # @return [Object] Object resource
    def decode_body(str)
      @serializer.decode(str)
    end

    # Make a HTTP request to a path and returns an Array of Resources
    #
    # @param method [Symbol] HTTP verb to use.
    # @param path [String] The path, relative to {#api_endpoint}.
    # @param data [Hash] Data to be send in the request's body
    #   it can include query: key with requests params for GET requests
    # @param options [Hash] A customizable set of request options.
    # @return [Array<BookingSync::API::Resource>] Array of resources.
    def request(method, path, data = nil, options = nil)
      instrument("request.bookingsync_api", method: method, path: path) do
        response = call(method, path, data, options)
        response.respond_to?(:resources) ? response.resources : response
      end
    end

    # Make a HTTP GET request to a path with pagination support.
    #
    # @param options [Hash]
    # @option options [Integer] per_page: Number of resources per page
    # @option options [Integer] page: Number of page to return
    # @option options [Boolean] auto_paginate: If true, all resources will
    #   be returned. It makes multiple requestes underneath and joins the results.
    #
    # @yieldreturn [Array<BookingSync::API::Resource>] Batch of resources
    # @return [Array<BookingSync::API::Resource>] Batch of resources
    def paginate(path, options = {}, &block)
      instrument("paginate.bookingsync_api", path: path) do
        auto_paginate = options.delete(:auto_paginate)
        response = call(:get, path, query: options)
        data = response.resources.dup

        if (block_given? or auto_paginate) && response.relations[:next]
          first_request = true
          loop do
            if block_given?
              yield(response.resources)
            elsif auto_paginate
              data.concat(response.resources) unless first_request
              first_request = false
            end
            break unless response.relations[:next]
            response = response.relations[:next].get
          end
        end

        data
      end
    end

    # Make a HTTP request to given path and returns Response object.
    #
    # @param method [Symbol] HTTP verb to use.
    # @param path [String] The path, relative to {#api_endpoint}.
    # @param data [Hash] Data to be send in the request's body
    #   it can include query: key with requests params for GET requests
    # @param options [Hash] A customizable set of request options.
    # @return [BookingSync::API::Response] A Response object.
    def call(method, path, data = nil, options = nil)
      instrument("call.bookingsync_api", method: method, path: path) do
        request_params = {
          :method => method,
          :headers => { "Authorization" => "Bearer #{token}" }
        }

        if [:get, :head].include?(method)
          options = data
          data = nil
        end

        if options.has_key?(:query)
          if options[:query].has_key?(:ids)
            ids = Array(options[:query].delete(:ids)).join(',')
            path = "#{path}/#{ids}"
          end
          options[:query].keys.each do |key|
            if options[:query][key].is_a?(Array)
              options[:query][key] = options[:query][key].join(",")
            end
          end
        end

        request_params[:path] = "api/v3/#{path}"
        request_params[:data] = data if data
        request_params[:query] = options[:query]
        request_params[:headers].update options[:headers] if options[:headers]

        res = @conn.request(request_params)

        handle_response(res)
      end
    end

    private

    def middleware
      Faraday::RackBuilder.new do |builder|
        builder.use :logger, logger
        builder.adapter Faraday.default_adapter
      end
    end

    def faraday_options
      { builder: middleware, ssl: { verify: verify_ssl? } }
    end

    # Return BookingSync base URL. Default is https://www.bookingsync.com
    # it can be altered via ENV variable BOOKINGSYNC_URL which
    # is useful in specs when recording vcr cassettes. In also can be passed
    # as :base_url option when initializing the Client object
    #
    # @return [String] Base URL to BookingSync
    def base_url
      @base_url || ENV.fetch("BOOKINGSYNC_URL", "https://www.bookingsync.com")
    end

    # Return true if SSL cert should be verified
    # By default is true, can be changed to false using
    # env variable VERIFY_SSL
    #
    # @return [Boolean] true if SSL needs to be verified
    # false otherwise
    def verify_ssl?
      ENV["BOOKINGSYNC_VERIFY_SSL"] != "false"
    end

    # Expand an URL template into a full URL
    #
    # @param url [String|Addressable::Template] - An URL to be expanded
    # @param options [Hash] - Variables which will be used to expand
    # @return [String] - Expanded URL
    def expand_url(url, options = nil)
      tpl = url.respond_to?(:expand) ? url : ::Addressable::Template.new(url.to_s)
      tpl.expand(options || {}).to_s
    end

    # Process faraday response.
    #
    # @param faraday_response [Faraday::Response] - A response to process
    # @raise [BookingSync::API::Unauthorized] - On unauthorized user
    # @raise [BookingSync::API::UnprocessableEntity] - On validations error
    # @return [BookingSync::API::Response|NilClass]
    def handle_response(excon_response)
      @last_response = response = ExconResponse.new(self, excon_response)
      case response.status
      when 204; nil # destroy/cancel
      when 200..299; response
      when 401; raise Unauthorized.new(response)
      when 403; raise Forbidden.new(response)
      when 404; raise NotFound.new(response)
      when 422; raise UnprocessableEntity.new(response)
      else raise UnsupportedResponse.new(response)
      end
    end

    def debug?
      ENV["BOOKINGSYNC_API_DEBUG"] == "true"
    end

    # Return default logger. By default we don't log anywhere.
    # If we are in debug mode, we log everything to STDOUT.
    #
    # @return [Logger] Logger where faraday middleware will log requests and
    #   responses.
    def default_logger
      Logger.new(debug? ? STDOUT : nil)
    end

    # Return user agent with gem version, can be logged in API.
    def user_agent
      "BookingSync API gem v#{BookingSync::API::VERSION}"
    end

    # Default instrumenter which does nothing.
    module NoopInstrumenter
      def self.instrument(name, payload = {})
        yield payload if block_given?
      end
    end
  end
end