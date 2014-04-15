module BookingSync::API
  class Client
    module  RatesTables
      # List rates table
      #
      # Returns rates tables for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<Sawyer::Resource>] Array of rates tables.
      #
      # @example Get the list of rates tables for the current account
      #   rates_tables = @api.rates_tables
      #   rates_tables.first.name # => "Rates table 2"
      # @example Get the list of rates tables only with name and account_id for smaller response
      #   @api.rates_tables(fields: [:name, :account_id])
      # @see http://docs.api.bookingsync.com/reference/endpoints/rates_tables/#list-rates-tables
      def rates_tables(options = {}, &block)
        paginate :rates_tables, options, &block
      end
    end
  end
end
