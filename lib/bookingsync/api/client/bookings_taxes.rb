module BookingSync::API
  class Client
    module BookingsTaxes
      # List bookings taxes
      #
      # Returns bookings taxes for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of bookings taxes.
      #
      # @example Get the list of bookings taxes for the current account
      #   bookings_taxes = @api.bookings_taxes
      #   bookings_taxes.first.percentage # => 20.0
      # @example Get the list of bookings taxes only with percentage for smaller response
      #   @api.bookings_taxes(fields: [:percentage])
      # @see http://docs.api.bookingsync.com/reference/endpoints/bookings_taxes/#list-bookings_taxes
      def bookings_taxes(options = {}, &block)
        paginate :bookings_taxes, options, &block
      end
    end
  end
end
