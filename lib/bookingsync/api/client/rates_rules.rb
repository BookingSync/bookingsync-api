module BookingSync::API
  class Client
    module  RatesRules
      # List rates rules
      #
      # Returns rates rules for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<Sawyer::Resource>] Array of rates rules.
      #
      # @example Get the list of rates rules for the current account
      #   rates_rules = @api.rates_rules
      #   rates_rules.first.always_applied # => true
      # @example Get the list of rates rules only with always_applied and kind for smaller response
      #   @api.rates_rules(fields: [:always_applied, :kind])
      # @see http://docs.api.bookingsync.com/reference/endpoints/rates_rules/#list-rates-rules
      def rates_rules(options = {}, &block)
        paginate :rates_rules, options, &block
      end
    end
  end
end
