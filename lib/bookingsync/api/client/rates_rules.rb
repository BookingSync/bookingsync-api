module BookingSync::API
  class Client
    module  RatesRules
      # List rates rules
      #
      # Returns rates rules for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of rates rules.
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

      # Get a single rates_rule
      #
      # @param rates_rule [BookingSync::API::Resource|Integer] RatesRule or ID
      #   of the rates_rule.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def rates_rule(rates_rule, options = {})
        get("rates_rules/#{rates_rule}", options).pop
      end

      # Create a new rates_rule
      #
      # @param rates_table [BookingSync::API::Resource|Integer] RatesTable or ID of
      #   the rates_table for which rates_rule will be created.
      # @param options [Hash] RatesRule's attributes.
      # @return [BookingSync::API::Resource] Newly created rates_rule.
      def create_rates_rule(rates_table, options = {})
        post("rates_tables/#{rates_table}/rates_rules", rates_rules: [options]).pop
      end

      # Edit a rates_rule
      #
      # @param rates_rule [BookingSync::API::Resource|Integer] RatesRule or ID of
      #   the rates_rule to be updated.
      # @param options [Hash] RatesRule attributes to be updated.
      # @return [BookingSync::API::Resource] Updated rates_rule on success,
      #   exception is raised otherwise.
      # @example
      #   rates_rule = @api.rates_rules.first
      #   @api.edit_rates_rule(rates_rule, { percentage: 10 })
      def edit_rates_rule(rates_rule, options = {})
        put("rates_rules/#{rates_rule}", rates_rules: [options]).pop
      end

      # Delete a rates_rule
      #
      # @param rates_rule [BookingSync::API::Resource|Integer] RatesRule or ID
      #   of the rates_rule to be deleted.
      # @return [NilClass] Returns nil on success.
      def delete_rates_rule(rates_rule)
        delete "rates_rules/#{rates_rule}"
      end
    end
  end
end
