module BookingSync::API
  class Client
    module ReservationsRequests
      # List reservations requests
      #
      # Returns reservations requests for the current account.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of reservations requests.
      # @see http://developers.bookingsync.com/reference/endpoints/reservations_requests/#list-reservations-requests
      def reservations_requests(options = {}, &block)
        paginate "reservations/requests", options, &block
      end

      # Get a single reservations request
      #
      # @param id [BookingSync::API::Resource|Integer] Reservations request or ID
      #   of the reservations request.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def reservations_request(id, options = {})
        get("reservations/requests/#{id}", options).pop
      end

      # Create a new reservations request
      #
      # @param options [Hash] Reservations request attributes.
      # @return [BookingSync::API::Resource] Newly created reservations request.
      def create_reservation_request(options = {})
        post("reservations/requests", reservations_requests: [options]).pop
      end

      # Edit a reservations request
      #
      # @param id [BookingSync::API::Resource|Integer] Reservations request or ID of
      #   the reservations request to be updated.
      # @param options [Hash] Reservations request attributes to be updated.
      # @return [BookingSync::API::Resource] Updated reservations request on success,
      #   exception is raised otherwise.
      def patch_reservation_request(id, options = {})
        patch("reservations/requests/#{id}", reservations_requests: [options]).pop
      end

      # Delete a reservations request
      #
      # Soft-cancels the given reservations request.
      # @param id [BookingSync::API::Resource|Integer] Reservations request or ID of
      #   the reservations request to be deleted.
      # @return [NilClass] Returns nil on success.
      def delete_reservation_request(id)
        delete "reservations/requests/#{id}"
      end
    end
  end
end
