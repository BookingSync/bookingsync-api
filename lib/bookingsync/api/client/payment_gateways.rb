module BookingSync::API
  class Client
    module PaymentGateways
      # List payment gateways
      #
      # Returns payment gateways for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of payment gateways.
      #
      # @example Get the list of payment gateways for the current account
      #   payment_gateways = @api.payment_gateways
      #   payment_gateways.first.gateway_name # => "blue_pay"
      # @example Get the list of payment gateways only with gateway_name for smaller response
      #   @api.payment_gateways(fields: [:gateway_name])
      # @see http://developers.bookingsync.com/reference/endpoints/payment_gateways/#list-payment_gateways
      def payment_gateways(options = {}, &block)
        paginate :payment_gateways, options, &block
      end

      # Get a single payment gateway
      #
      # @param payment_gateway [BookingSync::API::Resource|Integer] PaymentGateway or ID
      #   of the payment gateway.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def payment_gateway(payment_gateway, options = {})
        get("payment_gateways/#{payment_gateway}", options).pop
      end
    end
  end
end
