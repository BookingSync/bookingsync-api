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

      # Create a new rental agreement for a booking
      #
      # @param booking_id [Integer] ID of the booking
      # @param options [Hash] rental agreement attributes
      # @return <Sawyer::Resource> Newly created rental agreement
      def create_rental_agreement_for_booking(booking_id, options = {})
        post(:rental_agreements, booking_id: booking_id, 
             rental_agreements: [options]).pop
      end

      # Create a new rental agreement for a rental
      #
      # @param rental_id [Integer] ID of the rental
      # @param options [Hash] rental agreement attributes
      # @return <Sawyer::Resource> Newly created rental agreement
      def create_rental_agreement_for_rental(rental_id, options = {})
        post(:rental_agreements, rental_id: rental_id, 
             rental_agreements: [options]).pop
      end

      # Create a new rental agreement for an account
      #
      # @param options [Hash] rental agreement attributes
      # @return <Sawyer::Resource> Newly created rental agreement
      def create_rental_agreement(options = {})
        post(:rental_agreements, rental_agreements: [options]).pop
      end
    end
  end
end
