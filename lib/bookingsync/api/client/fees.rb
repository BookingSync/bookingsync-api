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
      # @see http://developers.bookingsync.com/reference/endpoints/fees/#list-fees
      def fees(options = {}, &block)
        paginate :fees, options, &block
      end

      # Get a single fee
      #
      # @param fee [BookingSync::API::Resource|Integer] Fee or ID
      #   of the fee.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def fee(fee, options = {})
        get("fees/#{fee}", options).pop
      end

      # Create a new fee
      #
      # @param options [Hash] Fee's attributes.
      # @return [BookingSync::API::Resource] Newly created fee.
      def create_fee(options = {})
        post(:fees, fees: [options]).pop
      end
    end
  end
end
