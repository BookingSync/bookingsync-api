module BookingSync::API
  class Client
    module RentalAgreements
      # List rental agreements.
      #
      # Returns rental agreements for the rentals of the account
      #   user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of rental agreements.
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

      # Create a new rental agreement for a booking.
      #
      # @param booking [BookingSync::API::Resource|Integer] Booking or ID of
      #   the booking for which rental agreement will be created.
      # @param options [Hash] Rental agreement's attributes.
      # @return [BookingSync::API::Resource] Newly created rental agreement.
      def create_rental_agreement_for_booking(booking, options = {})
        post("bookings/#{booking}/rental_agreements",
          rental_agreements: [options]).pop
      end

      # Create a new rental agreement for a rental.
      #
      # @param rental [BookingSync::API::Resource|Integer] Rental or ID of
      #   the rental for which rental agreement will be created.
      # @param options [Hash] Rental agreement's attributes.
      # @return [BookingSync::API::Resource] Newly created rental agreement
      def create_rental_agreement_for_rental(rental, options = {})
        post("rentals/#{rental}/rental_agreements",
          rental_agreements: [options]).pop
      end

      # Create a new rental agreement for an account.
      #
      # @param options [Hash] Rental agreement's attributes.
      # @return [BookingSync::API::Resource] Newly created rental agreement.
      def create_rental_agreement(options = {})
        post(:rental_agreements, rental_agreements: [options]).pop
      end
    end
  end
end
