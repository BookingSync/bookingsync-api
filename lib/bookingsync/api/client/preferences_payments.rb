module BookingSync::API
  class Client
    module PreferencesPayments
      # List preferences payments
      #
      # Returns preferences payments for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of preferences payments.
      #
      # @example Get the list of preferences payments for the current account
      #   preferences_payments = @api.preferences_payments
      #   preferences_payments.first.gateway # => "blue_pay"
      # @example Get the list of preferences payments only with gateway and supported_cardtypes for smaller response
      #   @api.preferences_payments(fields: [:gateway, :supported_cardtypes])
      # @see http://developers.bookingsync.com/reference/endpoints/preferences_payments/#list-preferences-payments
      def preferences_payments(options = {}, &block)
        paginate :preferences_payments, options, &block
      end
    end
  end
end
