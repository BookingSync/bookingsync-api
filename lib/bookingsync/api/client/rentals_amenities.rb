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
      # @see http://docs.api.bookingsync.com/reference/endpoints/rentals_amenities/#list-rentals-amenities
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
    end
  end
end
