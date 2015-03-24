module BookingSync::API
  class Client
    module Taxes
      # List taxes
      #
      # Returns taxes for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of taxes.
      #
      # @example Get the list of taxes for the current account
      #   taxes = @api.taxes
      #   taxes.first.percentage # => 20.0
      # @example Get the list of taxes only with percentage for smaller response
      #   @api.taxes(fields: [:percentage])
      # @see http://docs.api.bookingsync.com/reference/endpoints/taxes/#list-taxes
      def taxes(options = {}, &block)
        paginate :taxes, options, &block
      end
    end
  end
end
