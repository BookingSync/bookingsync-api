module BookingSync::API
  class Client
    module BookingsPayments
      # List bookings payments
      #
      # Returns bookings payments for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<Sawyer::Resource>] Array of bookings payments.
      #
      # @example Get the list of bookings payments for the current account
      #   bookings_payments = @api.bookings_payments
      #   bookings_payments.first.amount # => 200
      # @example Get the list of bookings payments only with amount and currency for smaller response
      #   @api.bookings_payments(fields: [:amount, :currency])
      # @see http://docs.api.bookingsync.com/reference/endpoints/bookings_payments/#list-bookings-payments
      def bookings_payments(options = {}, &block)
        paginate :bookings_payments, options, &block
      end
    end
  end
end
