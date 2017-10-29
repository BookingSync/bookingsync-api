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
      # @see http://developers.bookingsync.com/reference/endpoints/bookings/#list-bookings
      # @see http://developers.bookingsync.com/reference/endpoints/bookings/#search-bookings
      def bookings(options = {}, &block)
        paginate :bookings, options, &block
      end

      # Get a single booking
      #
      # @param booking [BookingSync::API::Resource|Integer] Booking or ID
      #   of the booking.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @option options [Boolean] include_canceled: If true canceled bookings
      #   are shown, otherwise they are hidden.
      # @return [BookingSync::API::Resource]
      def booking(booking, options = {})
        get("bookings/#{booking}", options).pop
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
      # @param options [Hash] Booking attributes to be updated.
      #   (For now, only `cancelation_reason` is allowed)
      # @return [NilClass] Returns nil on success.
      # @example
      #   @api.cancel_booking(booking_id)
      #
      # @example Providing cancelation_reason
      #   @api.cancel_booking(booking_id, { cancelation_reason: "payment_failed" })
      def cancel_booking(booking, options = nil)
        options = { bookings: [options] } if options
        delete "bookings/#{booking}", options
      end

      # Add a bookings_fee
      #
      # @param booking [BookingSync::API::Resource|Integer] Booking or ID of the booking
      # for which the fee should be added
      # @param options [Hash] Bookings_fee attributes.
      # @return [BookingSync::API::Resource] Booking attributes, fees included
      # @example
      #   booking = @api.bookings.first
      #   @api.add_bookings_fee(booking, { price: 100, times_booked: 2 })
      def add_bookings_fee(booking, options = {})
        patch("bookings/#{booking}/add_bookings_fee", bookings_fees: [options]).pop
      end

      # Remove a bookings_fee
      #
      # @param booking [BookingSync::API::Resource|Integer] Booking or ID of the booking
      # for which the fee should be removed
      # @param options [Integer] ID of the bookings_fee to be removed.
      # @return [BookingSync::API::Resource] Booking attributes, remaining fees included
      # @example
      #   booking = @api.bookings.first
      #   @api.remove_bookings_fee(booking, 1)
      def remove_bookings_fee(booking, bookings_fee_id)
        patch("bookings/#{booking}/remove_bookings_fee/#{bookings_fee_id}").pop
      end
    end
  end
end
