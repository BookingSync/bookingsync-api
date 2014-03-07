module BookingSync::API
  class Client
    module Bookings
      # List bookings
      #
      # Return public future bookings for the account user
      # is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<Sawyer::Resource>] Array of bookings.
      def bookings(options = {})
        get :bookings, options
      end
    end
  end
end
