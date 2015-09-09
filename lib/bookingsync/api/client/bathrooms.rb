module BookingSync::API
  class Client
    module Bathrooms
      # List bathrooms
      #
      # Returns bathrooms for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of bathrooms.
      #
      # @example Get the list of bathrooms for the current account
      #   bathrooms = @api.bathrooms
      #   bathrooms.first.name # => "Bathroom 2"
      # @example Get the list of bathrooms only with name for smaller response
      #   @api.bathrooms(fields: [:name])
      def bathrooms(options = {}, &block)
        paginate :bathrooms, options, &block
      end

      # Get a single bathroom
      #
      # @param bathroom [BookingSync::API::Resource|Integer] Bedroom or ID
      #   of the bathroom.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def bathroom(bathroom, options = {})
        get("bathrooms/#{bathroom}", options).pop
      end

      # Create a new bathroom
      #
      # @param rental [BookingSync::API::Resource|Integer] Rental or ID of
      #   the rental for which bathroom will be created.
      # @param options [Hash] Bathroom's attributes.
      # @return [BookingSync::API::Resource] Newly created bathroom.
      def create_bathroom(rental, options = {})
        post("rentals/#{rental}/bathrooms", bathrooms: [options]).pop
      end

      # Edit a bathroom
      #
      # @param bathroom [BookingSync::API::Resource|Integer] Bathroom or ID of
      #   the bathroom to be updated.
      # @param options [Hash] Bathroom attributes to be updated.
      # @return [BookingSync::API::Resource] Updated bathroom on success,
      #   exception is raised otherwise.
      # @example
      #   bathroom = @api.bathrooms.first
      #   @api.edit_bathroom(bathroom, { name: "Some bathroom" })
      def edit_bathroom(bathroom, options = {})
        put("bathrooms/#{bathroom}", bathrooms: [options]).pop
      end

      # Cancel a bathroom
      #
      # @param bathroom [BookingSync::API::Resource|Integer] Bathroom or ID
      #   of the bathroom to be canceled.
      # @return [NilClass] Returns nil on success.
      def cancel_bathroom(bathroom)
        delete "bathrooms/#{bathroom}"
      end
    end
  end
end
