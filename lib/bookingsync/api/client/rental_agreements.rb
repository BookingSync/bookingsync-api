module BookingSync::API
  class Client
    module RentalAgreements
      # List rental agreements
      #
      # Returns rental agreements for the rentals of the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<Sawyer::Resource>] Array of rental agreements.
      #
      # @example Get the list of rental agreements for the current account
      #   agreement = @api.rental_agreements
      #   agreement.first.body # => "My rental agreement"
      # @example Get the list of rental agreements only with body for smaller response
      #   @api.rentals(fields: :body)
      # @see http://docs.api.bookingsync.com/reference/endpoints/rental_agreements/#list-rental_agreements
      def rental_agreements(options = {}, &block)
        paginate :rental_agreements, options, &block
      end
    end
  end
end
