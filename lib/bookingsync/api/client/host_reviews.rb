module BookingSync::API
  class Client
    module HostReviews
      # List host reviews
      #
      # Returns host reviews for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of reviews.
      #
      # @example Get the list of host reviews for the current account
      #   host_reviews = @api.host_reviews
      #   host_reviews.first.is_guest_recommended # => true
      # @example Get the list of host reviews only with submitted_at and comment for smaller response
      #   @api.host_reviews(fields: [:submitted_at, :comment])
      # @see http://developers.bookingsync.com/reference/endpoints/host_reviews/#list-host-reviews
      def host_reviews(options = {}, &block)
        paginate :host_reviews, options, &block
      end

      # Get a single host review
      #
      # @param host review [BookingSync::API::Resource|String] HostReview or ID
      #   of the host review.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def host_review(host_review, options = {})
        get("host_reviews/#{host_review}", options).pop
      end

      # Create a new non-submitted host review
      #
      # @param booking [BookingSync::API::Resource|Integer] Booking or ID of
      #   the booking for which a host review will be created.
      # @param options [Hash] Host Review's attributes.
      # @return [BookingSync::API::Resource] Newly created host review.
      def create_draft_host_review(booking, options = {})
        post("bookings/#{booking}/host_reviews/draft", host_reviews: [options]).pop
      end

      # Create a new submitted host review
      #
      # @param booking [BookingSync::API::Resource|Integer] Booking or ID of
      #   the booking for which a host review will be created.
      # @param options [Hash] Host Review's attributes.
      # @return [BookingSync::API::Resource] Newly created host review.
      def create_submitted_host_review(booking, options = {})
        post("bookings/#{booking}/host_reviews", host_reviews: [options]).pop
      end

      # Edit a draft host review
      #
      # @param host review [BookingSync::API::Resource|String] Host Review or ID of
      #   the host review to be updated.
      # @param options [Hash] Host review attributes to be updated.
      # @return [BookingSync::API::Resource] Updated host review on success,
      #   exception is raised otherwise.
      # @example
      #   host_review = @api.host_reviews.first
      #   @api.edit_host_review(host_review, { comment: "Thanks for being such a great guest!", submitted_at: "20201-03-22T12:00:00Z" })
      def edit_draft_host_review(host_review, options = {})
        put("host_reviews/draft/#{host_review}", host_reviews: [options]).pop
      end

      # Submit a draft host review
      #
      # @param host review [BookingSync::API::Resource|String] Host Review or ID of
      #   the host review to be updated.
      # @param options [Hash] Host review attributes to be updated.
      # @return [BookingSync::API::Resource] Updated host review on success,
      #   exception is raised otherwise.
      # @example
      #   host_review = @api.host_reviews.first
      #   @api.edit_host_review(host_review, { comment: "Thanks for being such a great guest!", submitted_at: "20201-03-22T12:00:00Z" })
      def submit_draft_host_review(host_review, options = {})
        put("host_reviews/draft/#{host_review}/submit", host_reviews: [options]).pop
      end

      # Dismiss a host review
      #
      # @param host review [BookingSync::API::Resource|String] Host Review or ID of
      #   the host review to be dismissed.
      # @param options [Hash] Host review dismissal attributes.
      # @return [BookingSync::API::Resource] Dismissed host review on success,
      #   exception is raised otherwise.
      # @example
      #   host_review = @api.host_reviews.first
      #   @api.dismiss_host_review(host_review, { dismissed_at: "20201-03-22T12:00:00Z" })
      def dismiss_host_review(host_review, options = {})
        put("host_reviews/#{host_review}/dismiss", host_reviews: [options]).pop
      end
    end
  end
end
