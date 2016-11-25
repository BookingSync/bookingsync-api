module BookingSync::API
  class Client
    module LivingRooms
      # List living_rooms
      #
      # Returns living_rooms for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of living_rooms.
      #
      # @example Get the list of living_rooms for the current account
      #   living_rooms = @api.living_rooms
      #   living_rooms.first.bunk_beds_count # => 2
      # @example Get the list of living_rooms only with bunk_beds_count for smaller response
      #   @api.living_rooms(fields: [:bunk_beds_count])
      def living_rooms(options = {}, &block)
        paginate :living_rooms, options, &block
      end

      # Get a single living_room
      #
      # @param living_room [BookingSync::API::Resource|Integer] LivingRoom or ID
      #   of the living_room.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def living_room(living_room, options = {})
        get("living_rooms/#{living_room}", options).pop
      end

      # Create a new living_room
      #
      # @param rental [BookingSync::API::Resource|Integer] Rental or ID of
      #   the rental for which living_room will be created.
      # @param options [Hash] LivingRoom's attributes.
      # @return [BookingSync::API::Resource] Newly created living_room.
      def create_living_room(rental, options = {})
        post("rentals/#{rental}/living_rooms", living_rooms: [options]).pop
      end

      # Edit a living_room
      #
      # @param living_room [BookingSync::API::Resource|Integer] LivingRoom or ID of
      #   the living_room to be updated.
      # @param options [Hash] LivingRoom attributes to be updated.
      # @return [BookingSync::API::Resource] Updated living_room on success,
      #   exception is raised otherwise.
      # @example
      #   living_room = @api.living_rooms.first
      #   @api.edit_living_room(living_room, { bunk_beds_count: 3 })
      def edit_living_room(living_room, options = {})
        put("living_rooms/#{living_room}", living_rooms: [options]).pop
      end

      # Cancel a living_room
      #
      # @param living_room [BookingSync::API::Resource|Integer] LivingRoom or ID
      #   of the living_room to be canceled.
      # @return [NilClass] Returns nil on success.
      def cancel_living_room(living_room)
        delete "living_rooms/#{living_room}"
      end
    end
  end
end
