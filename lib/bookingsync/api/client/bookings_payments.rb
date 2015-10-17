module BookingSync::API
  class Client
    module BookingsPayments
      # List bookings payments
      #
      # Returns bookings payments for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of bookings payments.
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

      # Get a single bookings payment
      #
      # @param bookings_payment [BookingSync::API::Resource|Integer] BookingsPayment or ID
      #   of the bookings payment.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def bookings_payment(bookings_payment, options = {})
        get("bookings_payments/#{bookings_payment}", options).pop
      end
    end
  end
end
