module BookingSync::API
  class Client
    module RentalsFees
      # List rentals fees
      #
      # Returns rentals fees for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of rentals fees.
      #
      # @example Get the list of rentals fees for the current account
      #   rentals_fees = @api.rentals fees
      #   rentals_fees.first.always_applied # => true
      # @example Get the list of rentals fees only with start_date and end_date for smaller response
      #   @api.rentals fees(fields: [:start_date, :end_date])
      # @see http://docs.api.bookingsync.com/reference/endpoints/rentals_fees/#list-rentals_fees
      def rentals_fees(options = {}, &block)
        paginate :rentals_fees, options, &block
      end

      # Get a single rentals_fee
      #
      # @param rentals_fee [BookingSync::API::Resource|Integer] RentalsFee or ID
      #   of the rentals_fee.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def rentals_fee(rentals_fee, options = {})
        get("rentals_fees/#{rentals_fee}", options).pop
      end

      # Create a new rentals_fee
      #
      # @param rental [BookingSync::API::Resource|Integer] Rental or ID of
      #   the rental for which rentals_fee will be created.
      # @param options [Hash] RentalsFee's attributes.
      # @return [BookingSync::API::Resource] Newly created rentals_fee.
      def create_rentals_fee(rental, options = {})
        post("rentals/#{rental}/rentals_fees", rentals_fees: [options]).pop
      end
    end
  end
end
