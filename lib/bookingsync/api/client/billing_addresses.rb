module BookingSync::API
  class Client
    module BillingAddresses
      # List billing addresses
      #
      # Returns billing addresses for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of billing addresses.
      #
      # @example Get the list of billing addresses for the current account
      #   billing_addresses = @api.billing_addresses
      #   billing_addresses.first.city # => "Paris"
      # @example Get the list of billing addresses only with city and address1 for smaller response
      #   @api.billing_addresses(fields: [:city, :address1])
      # @see http://docs.api.bookingsync.com/reference/endpoints/billing addresss/#list-billing-addresses
      def billing_addresses(options = {}, &block)
        paginate :billing_addresses, options, &block
      end
    end
  end
end
