module BookingSync::API
  class Client
    module Amenities
      # List amenities
      #
      # Returns all amenities supported in BookingSync.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of amenities.
      #
      # @example Get the list of amenities for the current account
      #   amenities = @api.amenities
      #   amenities.first.title # => "Internet"
      # @see http://docs.api.bookingsync.com/reference/endpoints/amenities/#list-amenities
      def amenities(options = {}, &block)
        paginate :amenities, options, &block
      end

      # Get a single amenity
      #
      # @param amenity [BookingSync::API::Resource|Integer] Amenity or ID
      #   of the amenity.
      # @return [BookingSync::API::Resource]
      def amenity(amenity)
        get("amenities/#{amenity}").pop
      end
    end
  end
end
