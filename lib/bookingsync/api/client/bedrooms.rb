module BookingSync::API
  class Client
    module Bedrooms
      # List bedrooms
      #
      # Returns bedrooms for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of bedrooms.
      #
      # @example Get the list of bedrooms for the current account
      #   bedrooms = @api.bedrooms
      #   bedrooms.first.name # => "Bedroom 2"
      # @example Get the list of bedrooms only with name for smaller response
      #   @api.bedrooms(fields: [:name])
      def bedrooms(options = {}, &block)
        paginate :bedrooms, options, &block
      end

      # Get a single bedroom
      #
      # @param bedroom [BookingSync::API::Resource|Integer] Bedroom or ID
      #   of the bedroom.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def bedroom(bedroom, options = {})
        get("bedrooms/#{bedroom}", options).pop
      end

      # Create a new bedroom
      #
      # @param rental [BookingSync::API::Resource|Integer] Rental or ID of
      #   the rental for which bedroom will be created.
      # @param options [Hash] Bedroom's attributes.
      # @return [BookingSync::API::Resource] Newly created bedroom.
      def create_bedroom(rental, options = {})
        post("rentals/#{rental}/bedrooms", bedrooms: [options]).pop
      end

      # Edit a bedroom
      #
      # @param bedroom [BookingSync::API::Resource|Integer] Bedroom or ID of
      #   the bedroom to be updated.
      # @param options [Hash] Bedroom attributes to be updated.
      # @return [BookingSync::API::Resource] Updated bedroom on success,
      #   exception is raised otherwise.
      # @example
      #   bedroom = @api.bedrooms.first
      #   @api.edit_bedroom(bedroom, { name: "Some bedroom" })
      def edit_bedroom(bedroom, options = {})
        put("bedrooms/#{bedroom}", bedrooms: [options]).pop
      end

      # Cancel a bedroom
      #
      # @param bedroom [BookingSync::API::Resource|Integer] Bedroom or ID
      #   of the bedroom to be canceled.
      # @return [NilClass] Returns nil on success.
      def cancel_bedroom(bedroom)
        delete "bedrooms/#{bedroom}"
      end
    end
  end
end
