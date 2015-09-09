module BookingSync::API
  class Client
    module RentalsAmenities
      # List rentals_amenities
      #
      # Returns all amenities used by rentals for the current account.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of rentals_amenities.
      #
      # @example Get the list of amenities for the current account
      #   rentals_amenities = @api.rentals_amenities
      #   rentals_amenities.first.amenity.title # => "Internet"
      # @see http://developers.bookingsync.com/reference/endpoints/rentals_amenities/#list-rentals-amenities
      def rentals_amenities(options = {}, &block)
        paginate :rentals_amenities, options, &block
      end

      # Get a single rentals_amenity
      #
      # @param rentals_amenity [BookingSync::API::Resource|Integer]
      # rentals_amenity or ID of the rentals_amenity.
      # @return [BookingSync::API::Resource]
      def rentals_amenity(rentals_amenity)
        get("rentals_amenities/#{rentals_amenity}").pop
      end

      # Create a rental's amenity
      #
      # @param rental [BookingSync::API::Resource|Integer] Rental object or ID
      #   for which the rental amenity will be created.
      # @param options [Hash] Rental Amenity' s attributes.
      # @return [BookingSync::API::Resource] Newly created rental's amenity.
      # @example Create a rental's amenity.
      #   @api.create_rentals_amenity(10, { amenity_id: 50 }) # Add the Internet amenity to the rental with ID 10
      # @see http://developers.bookingsync.com/reference/endpoints/rentals_amenities/#create-a-new-rentals-amenity
      def create_rentals_amenity(rental, options = {})
        post("rentals/#{rental}/rentals_amenities", rentals_amenities: [options]).pop
      end

      # Edit a rentals_amenity
      #
      # @param rentals_amenity [BookingSync::API::Resource|Integer] RentalsAmenity or ID of
      #   the rentals_amenity to be updated.
      # @param options [Hash] rentals_amenity attributes to be updated.
      # @return [BookingSync::API::Resource] Updated rentals_amenity on success,
      #   exception is raised otherwise.
      # @example
      #   rentals_amenity = @api.rentals_amenities.first
      #   @api.edit_rentals_amenity(rentals_amenity, { details_en: "Details" })
      def edit_rentals_amenity(rentals_amenity, options = {})
        put("rentals_amenities/#{rentals_amenity}", rentals_amenities: [options]).pop
      end

      # Delete a rentals_amenity
      #
      # @param rentals_amenity [BookingSync::API::Resource|Integer] RentalsAmenity or ID
      #   of the rentals_amenity to be deleted.
      # @return [NilClass] Returns nil on success.
      def delete_rentals_amenity(rentals_amenity)
        delete "rentals_amenities/#{rentals_amenity}"
      end
    end
  end
end
