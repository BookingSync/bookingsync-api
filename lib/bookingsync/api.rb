require "faraday"
require "faraday/net_http_persistent"
require "bookingsync/api/version"
require "bookingsync/api/client"

module BookingSync
  module API
    # Return new API Client
    #
    # @param token [String] OAuth token
    # @param options [Hash] Options for the API Client
    # @return [BookingSync::API::Client] New BookingSync API client
    def self.new(token, options = {})
      Client.new(token, options)
    end
  end
end
