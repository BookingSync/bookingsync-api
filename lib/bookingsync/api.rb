require "faraday"
require "sawyer"

require "bookingsync/ext/resource"
require "bookingsync/api/version"
require "bookingsync/api/client"

module BookingSync
  module API
    # Return new API Client
    #
    # @param token [String] OAuth token
    # @return [BookingSync::API::Client] New BookingSync API client
    def self.new(token)
      Client.new(token)
    end
  end
end
