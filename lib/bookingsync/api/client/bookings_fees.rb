module BookingSync::API
  class Client
    module BookingsFees
      # List bookings fees
      #
      # Returns bookings fees for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of bookings fees.
      #
      # @example Get the list of bookings fees for the current account
      #   bookings_fees = @api.bookings_fees
      #   bookings_fees.first.times_booked # => 1
      # @example Get the list of bookings fees only with times_booked for smaller response
      #   @api.bookings_fees(fields: [:times_booked])
      # @see http://docs.api.bookingsync.com/reference/endpoints/bookings_fees/#list-bookings_fees
      def bookings_fees(options = {}, &block)
        paginate :bookings_fees, options, &block
      end

      # Get a single bookings fee
      #
      # @param bookings_fee [BookingSync::API::Resource|Integer] BookingsFee or ID
      #   of the bookings fee.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def bookings_fee(bookings_fee, options = {})
        get("bookings_fees/#{bookings_fee}", options).pop
      end
    end
  end
end
