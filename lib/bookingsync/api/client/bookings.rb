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
      # @return [Array<BookingSync::API::Resource>] Array of bookings.
      # @example
      #   @api.bookings(months: 12, states: [:booked, :unavailable], include_canceled: true)
      #
      # @example Pagination
      #   @api.bookings(per_page: 10) do |batch|
      #     # do something with ten bookings
      #   end
      # @see http://docs.api.bookingsync.com/reference/endpoints/bookings/#list-bookings
      # @see http://docs.api.bookingsync.com/reference/endpoints/bookings/#search-bookings
      def bookings(options = {}, &block)
        paginate :bookings, options, &block
      end

      # Create a booking
      #
      # @param rental [BookingSync::API::Resource|Integer] Rental or ID of
      #   the rental for which booking will be created.
      # @param options [Hash] Booking attributes.
      # @return [BookingSync::API::Resource] Newly create booking.
      def create_booking(rental, options = {})
        post("rentals/#{rental}/bookings", bookings: [options]).pop
      end

      # Edit a booking
      #
      # @param booking [BookingSync::API::Resource|Integer] Booking or ID of the booking
      #   to be updated
      # @param options [Hash] Booking attributes to be updated
      # @return [BookingSync::API::Resource] Updated booking on success, exception is raised otherwise
      # @example
      #   booking = @api.bookings.first
      #   @api.edit_booking(booking, { adults: 1 })
      def edit_booking(booking, options = {})
        put("bookings/#{booking}", bookings: [options]).pop
      end

      # Cancel a booking
      #
      # @param booking [BookingSync::API::Resource|Integer] Booking or ID of
      #   the booking to be canceled.
      # @return [NilClass] Returns nil on success.
      def cancel_booking(booking, options = {})
        delete "bookings/#{booking}"
      end
    end
  end
end
