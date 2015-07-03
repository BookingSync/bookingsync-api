module BookingSync::API
  class Client
    module InstantBookings
      # Create an instant booking
      #
      # @param options [Hash] Booking attributes.
      # @return [BookingSync::API::Resource] Newly created booking.
      def create_instant_booking(options = {})
        post("instant_bookings", bookings: [options]).pop
      end
    end
  end
end
