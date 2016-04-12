module BookingSync::API
  class Client
    module Rentals
      # List rentals
      #
      # Returns rentals for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of rentals.
      #
      # @example Get the list of rentals for the current account
      #   rentals = @api.rentals
      #   rentals.first.name # => "Small apartment"
      # @example Get the list of rentals only with name and description for smaller response
      #   @api.rentals(fields: [:name, :description])
      # @see http://developers.bookingsync.com/reference/endpoints/rentals/#list-rentals
      def rentals(options = {}, &block)
        paginate :rentals, options, &block
      end

      # Search rentals
      #
      # Returns list of light rentals. Composed of id, initial_price,
      # final_price and updated_at.
      #
      # @param options [Hash] A customizable set of options.
      # @return [Array<BookingSync::API::Resource>] Array of light rentals.
      #
      # @example Search rentals by rental type
      # villas = @api.rentals_search(rental_type: "villa")
      def rentals_search(options = {}, &block)
        ids = Array(options.delete(:ids)).join(",")
        options.merge!(id: ids, method: :post)
        paginate "rentals/search", options, &block
      end

      # Get a single rental
      #
      # @param rental [BookingSync::API::Resource|Integer] Rental or ID
      #   of the rental.
      # @return [BookingSync::API::Resource]
      def rental(rental)
        get("rentals/#{rental}").pop
      end

      # Create a new rental
      #
      # @param options [Hash] rental attributes
      # @return [BookingSync::API::Resource] Newly created rental
      def create_rental(options = {})
        post(:rentals, rentals: [options]).pop
      end

      # Edit a rental
      #
      # @param rental [BookingSync::API::Resource|Integer] rental or ID of the rental
      # to be updated
      # @param options [Hash] rental attributes to be updated
      # @return [BookingSync::API::Resource] Updated rental on success, exception is raised otherwise
      # @example
      #   rental = @api.rentals.first
      #   @api.edit_rental(rental, { sleeps: 3 })
      def edit_rental(rental, options = {})
        put("rentals/#{rental}", rentals: [options]).pop
      end

      # Delete a rental
      #
      # @param rental [BookingSync::API::Resource|Integer] Rental or ID
      #   of the rental to be deleted.
      # @return [NilClass] Returns nil on success.
      def delete_rental(rental)
        delete "rentals/#{rental}"
      end

      # Get meta information about rentals.
      #
      # @param rentals [Array] IDs of Rentals, leave empty for all account's rentals
      # @return [BookingSync::API::Resource]
      def rentals_meta(rentals = nil)
        rental_ids = Array(rentals).join(",")
        post("rentals/meta", id: rental_ids).pop
      end
    end
  end
end