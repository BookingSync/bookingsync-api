module BookingSync::API
  class Client
    module ReviewReplies
      # List review replies
      #
      # Returns review replies for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of review replies.
      #
      # @example Get the list of review replies for the current account
      #   review_replies = @api.review_replies
      #   review_replies.first.message # => "Thanks for the feedback!"
      # @example Get the list of review_replies only with message and submitted_at for smaller response
      #   @api.review_replies(fields: [:message, :submitted_at])
      # @see http://developers.bookingsync.com/reference/endpoints/review_replies/#list-review-replies
      def review_replies(options = {}, &block)
        paginate :review_replies, options, &block
      end

      # Get a single review reply
      #
      # @param review reply [BookingSync::API::Resource|String] Review Reply or ID
      #   of the review reply.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def review_reply(review_reply, options = {})
        get("review_replies/#{review_reply}", options).pop
      end

      # Create a new review reply
      #
      # @param review [BookingSync::API::Resource|Integer] Review or ID of
      #   the review for which a reply will be created.
      # @param options [Hash] Review's attributes.
      # @return [BookingSync::API::Resource] Newly created review.
      def create_guest_review_reply(review, options = {})
        post("reviews/#{review}/reply", review_replies: [options]).pop
      end

      # Create a new host review reply
      #
      # @param host review [BookingSync::API::Resource|Integer] HostReview or ID of
      #   the host review for which a reply will be created.
      # @param options [Hash] Review's attributes.
      # @return [BookingSync::API::Resource] Newly created review.
      def create_host_review_reply(host_review, options = {})
        post("host_reviews/#{host_review}/reply", review_replies: [options]).pop
      end
    end
  end
end
