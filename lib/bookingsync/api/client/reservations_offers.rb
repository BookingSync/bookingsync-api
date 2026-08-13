module BookingSync::API
  class Client
    # Client methods for the Reservations::Offer V3 endpoint
    # (path: reservations/offers). This is a sibling to ReservationsRequests
    # and is a different concept from SpecialOffers, which is a rental-level
    # discount API (path: rentals/{rental}/special_offers). The two coexist.
    #
    # Contract notes (verified against live Core), differing from
    # reservations_requests:
    #   - Request root key is `reservations_offers` (plural, array-wrapped),
    #     while the response root key is `offers` (asymmetric, same pattern
    #     as reservations_requests -> requests).
    #   - Offer attributes are flat, there is no `booking_payload` wrapper.
    #   - There is no `booking_id` on create, a booking is attached later via
    #     a separate Core-side AttachBooking command.
    #   - Money is `total_amount_cents` (integer cents), not a `final_price`
    #     string decimal like reservations_requests.
    module ReservationsOffers
      # List reservations offers
      #
      # Returns reservations offers for the current account.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of reservations offers.
      # @see http://developers.bookingsync.com/reference/endpoints/reservations_offers/#list-reservations-offers
      def reservations_offers(options = {}, &block)
        paginate "reservations/offers", options, &block
      end

      # Get a single reservations offer
      #
      # @param id [BookingSync::API::Resource|Integer] Reservations offer or ID
      #   of the reservations offer.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def reservations_offer(id, options = {})
        get("reservations/offers/#{id}", options).pop
      end

      # Create a new reservations offer
      #
      # @param options [Hash] Reservations offer attributes.
      #   Required: conversation_id, rental_id, client_id, start_date,
      #   end_date, adults, total_amount_cents, currency, expires_at.
      #   Optional: children.
      # @return [BookingSync::API::Resource] Newly created reservations offer.
      def create_reservation_offer(options = {})
        post("reservations/offers", reservations_offers: [options]).pop
      end

      # Edit a reservations offer
      #
      # A withdrawal is performed as a regular update transitioning the offer
      # to the `withdrawn` status, there is no dedicated withdraw endpoint on V3.
      # @param id [BookingSync::API::Resource|Integer] Reservations offer or ID of
      #   the reservations offer to be updated.
      # @param options [Hash] Reservations offer attributes to be updated.
      # @return [BookingSync::API::Resource] Updated reservations offer on success,
      #   exception is raised otherwise.
      def patch_reservation_offer(id, options = {})
        patch("reservations/offers/#{id}", reservations_offers: [options]).pop
      end

      # Delete a reservations offer
      #
      # Soft-cancels the given reservations offer (sets canceled_at). This is
      # distinct from a status transition to `withdrawn`, which is done via
      # {#patch_reservation_offer}.
      # @param id [BookingSync::API::Resource|Integer] Reservations offer or ID of
      #   the reservations offer to be deleted.
      # @return [NilClass] Returns nil on success.
      def delete_reservation_offer(id)
        delete "reservations/offers/#{id}"
      end
    end
  end
end
