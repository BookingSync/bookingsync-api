module BookingSync::API
  class Client
    module Availabilities
      # List availabilities
      #
      # Returns availabilities for the rentals of the account, user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of availabilities.
      #
      # @example Get the list of availabilities for the current account
      #   availabilities = @api.availabilities
      #   availabilities.first.start_date # => "2014-05-30"
      # @see http://developers.bookingsync.com/reference/endpoints/availabilities/#list-availabilities
      def availabilities(options = {}, &block)
        paginate :availabilities, options, &block
      end

      # Get a single availability
      #
      # @param availability [BookingSync::API::Resource|Integer] Availability or ID
      #   of the availability.
      # @return [BookingSync::API::Resource]
      def availability(availability)
        get("availabilities/#{availability}").pop
      end
    end
  end
end
