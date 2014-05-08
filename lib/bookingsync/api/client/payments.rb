module BookingSync::API
  class Client
    module Payments
      # List payments
      #
      # Returns payments for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of payments.
      #
      # @example Get the list of payments for the current account
      #   payments = @api.payments
      #   payments.first.kind # => "cash"
      # @example Get the list of payments only with kind and currency for smaller response
      #   @api.payments(fields: [:kind, :currency])
      # @see http://docs.api.bookingsync.com/reference/endpoints/payments/#list-payments
      def payments(options = {}, &block)
        paginate :payments, options, &block
      end

      # Create a new payment
      #
      # @param booking_id [Integer] ID of the booking
      # @param options [Hash] payment attributes
      # @return [BookingSync::API::Resource] Newly created payment
      def create_payment(booking_id, options = {})
        post(:payments, booking_id: booking_id, payments: [options]).pop
      end

      # Edit a payment
      #
      # @param payment [BookingSync::API::Resource|Integer] payment or ID of the payment
      # to be updated
      # @param options [Hash] payment attributes to be updated
      # @return [BookingSync::API::Resource] Updated payment on success, exception is raised otherwise
      # @example
      #   payment = @api.payments.first
      #   @api.edit_payment(payment, { currency: "EURO" })
      def edit_payment(payment, options = {})
        put("payments/#{payment}", payments: [options]).pop
      end

      # Cancel a payment
      #
      # @param payment [BookingSync::API::Resource|Integer] Payment or ID of
      #   the payment to be canceled.
      # @return [NilClass] Returns nil on success.
      def cancel_payment(payment)
        delete "payments/#{payment}"
      end
    end
  end
end
