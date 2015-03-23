module BookingSync::API
  class Client
    module Fees
      # List fees
      #
      # Returns fees for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of fees.
      #
      # @example Get the list of fees for the current account
      #   fees = @api.fees
      #   fees.first.rate # => 20.0
      # @example Get the list of fees only with name and rate for smaller response
      #   @api.fees(fields: [:name, :rate])
      # @see http://docs.api.bookingsync.com/reference/endpoints/fees/#list-fees
      def fees(options = {}, &block)
        paginate :fees, options, &block
      end
    end
  end
end
