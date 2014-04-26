module BookingSync::API
  class Client
    module Rentals
      # List rentals
      #
      # Returns rentals for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<Sawyer::Resource>] Array of rentals.
      #
      # @example Get the list of rentals for the current account
      #   rentals = @api.rentals
      #   rentals.first.name # => "Small apartment"
      # @example Get the list of rentals only with name and description for smaller response
      #   @api.rentals(fields: [:name, :description])
      # @see http://docs.api.bookingsync.com/reference/endpoints/rentals/#list-rentals
      def rentals(options = {}, &block)
        paginate :rentals, options, &block
      end

      # Create a new rental
      #
      # @param options [Hash] rental attributes
      # @return [Sawyer::Resource] Newly created rental
      def create_rental(options = {})
        post(:rentals, rentals: [options]).pop
      end

      # Edit a rental
      #
      # @param rental [Sawyer::Resource|Integer] rental or ID of the rental
      # to be updated
      # @param options [Hash] rental attributes to be updated
      # @return [Sawyer::Resource] Updated rental on success, exception is raised otherwise
      # @example
      #   rental = @api.rentals.first
      #   @api.edit_rental(rental, { sleeps: 3 }) => Sawyer::Resource
      def edit_rental(rental, options = {})
        put("rentals/#{rental}", rentals: [options]).pop
      end

      # Cancel a rental
      #
      # @param rental [Sawyer::Resource|Integer] rental or ID of the rental
      # to be canceled
      # @return [Array] An empty Array on success, exception is raised otherwise
      def cancel_rental(rental, options = {})
        delete "rentals/#{rental}"
      end
    end
  end
end
