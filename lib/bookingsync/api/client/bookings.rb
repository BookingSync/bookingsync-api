module BookingSync::API
  class Client
    module Bookings
      # List bookings
      #
      # Return public future bookings for the account user
      # is authenticated with.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @option options [Time] from: Select bookings ending after given date.
      # @option options [Time] until: Select bookings starting before given date.
      # @option options [Integer] months: Select bookings starting before
      #   :from + months, if :from is blank, current time is taken.
      # @option options [Boolean] include_canceled: If true canceled bookings
      #   are shown, otherwise they are hidden.
      # @option options [Array] status: Array of booking states.
      #   If specyfied bookings with given states are shown.
      #   Possible statuses: `:booked`, `:unavailable` and `:tentative`
      # @return [Array<Sawyer::Resource>] Array of bookings.
      # @example
      #   @api.bookings(months: 12, states: [:booked, :unavailable], include_canceled: true)
      def bookings(options = {})
        get :bookings, options
      end


      # Create a booking
      #
      # @param options [Hash] Booking attributes
      # @return <Sawyer::Resource> Newly create booking
      def create_booking(options = {})
        post(:bookings, bookings: [options]).pop
      end

      # Edit a booking
      #
      # @param booking [Sawyer::Resource|Integer] Booking or ID of the booking
      #   to be updated
      # @param options [Hash] Booking attributes to be updated
      # FIXME: should be changed resource
      # @return [Array] An empty Array on success, exception is raised otherwise
      # @example
      #   booking = @api.bookings.first
      #   @api.edit_booking(booking, {adults: 1}) => []
      def edit_booking(booking, options = {})
        put "bookings/#{booking}", bookings: [options]
      end

      # Cancel a booking
      #
      # @param booking [Sawyer::Resource|Integer] Booking or ID of the booking
      #   to be canceled
      # @return [Array] An empty Array on success, exception is raised otherwise
      def cancel_booking(booking, options = {})
        delete "bookings/#{booking}"
      end
    end
  end
end
