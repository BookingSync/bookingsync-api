module BookingSync::API
  class Client
    module StrictBookings
      # Create a strict booking
      #
      # @param options [Hash] Booking attributes.
      # @return [BookingSync::API::Resource] Newly created booking.
      def create_strict_booking(options = {})
        post("strict_bookings", bookings: [options]).pop
      end
    end
  end
end
