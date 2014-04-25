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

      # Create a new rates_table
      #
      # @param options [Hash] rates_table attributes
      # @return <Sawyer::Resource> Newly created rates table
      def create_rates_table(options = {})
        post(:rates_tables, rates_tables: [options]).pop
      end

      # Edit a rates_table
      #
      # @param rates_table [Sawyer::Resource|Integer] rates table or
      # ID of the rates table to be updated
      # @param options [Hash] rates table attributes to be updated
      # @return [Sawyer::Resource] Updated rates table on success,
      # exception is raised otherwise
      # @example
      #   rates_table = @api.rates_tables.first
      #   @api.edit_rates_table(rates_table, { name: "Lorem" }) => Sawyer::Resource
      def edit_rates_table(rates_table, options = {})
        put("rates_tables/#{rates_table}", rates_tables: [options]).pop
      end

      # delete a rates_table
      #
      # @param rates_table [Sawyer::Resource|Integer] rates table or
      # ID of the rates table to be deleteed
      # @return [Array] An empty Array on success, exception is raised otherwise
      def delete_rates_table(rates_table, options = {})
        delete "rates_tables/#{rates_table}"
      end
    end
  end
end
