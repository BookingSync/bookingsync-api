module BookingSync::API
  class Client
    module BookingComments
      # List booking comments

      # Returns booking comments for the account and rentals user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] rental_id: Rental ID that booking is assiociated with.
      # @return [Array<BookingSync::API::Resource>] Array of comments.
      #
      # @example Get the list of comments for the current account
      #   @api.booking_comments
      # => [{:links=>{:booking=>10}, :id=>1, :content=>"comment 1", :editable=>true, :created_at=>2016-04-18 12:06:15 UTC, :updated_at=>2016-04-18 12:06:15 UTC},
      #     {:links=>{:booking=>11}, :id=>2, :content=>"comment 2", :editable=>true, :created_at=>2016-04-18 12:06:25 UTC, :updated_at=>2016-04-18 12:06:25 UTC}]
      # @example Get the list of comments only for specific rental
      #   @api.booking_comments(rental_id: 1)
      # => [{:links=>{:booking=>10}, :id=>1, :content=>"comment 1", :editable=>true, :created_at=>2016-04-18 12:06:15 UTC, :updated_at=>2016-04-18 12:06:15 UTC}]
      def booking_comments(options = {}, &block)
        paginate :booking_comments, options, &block
      end

      # Get a single booking_comment
      #
      # @param booking_comment [BookingSync::API::Resource|Integer] BookingComment or ID of the booking_comment.
      # @return [BookingSync::API::Resource]
      #
      # @example Get single booking_comment
      # @api.booking_comment(1)
      # => {:links=>{:booking=>10}, :id=>1, :content=>"comment 1", :editable=>true, :created_at=>2016-04-18 12:06:15 UTC, :updated_at=>2016-04-18 12:06:15 UTC}
      def booking_comment(booking_comment, options = {})
        get("booking_comments/#{booking_comment}", options).pop
      end

      # Create new booking_comment for a booking
      #
      # @param booking [BookingSync::API::Resource|Integer] Booking or
      # ID of the Booking for which booking_comment will be created
      # @param options [Hash] BookingComment attributes.
      # @return [BookingSync::API::Resource] Newly created bookings comment.
      # @example Create bookings comment
      # @api.create_booking_comment(1, content: "Hello!")
      # => {:links=>{:booking=>1}, :id=>8, :content=>"Hello!", :editable=>true, :created_at=>2016-04-18 13:31:40 UTC, :updated_at=>2016-04-18 13:46:06 UTC}
      def create_booking_comment(booking, options = {})
        post("booking_comments", booking_id: booking, booking_comments: [options]).pop
      end

      # Edit a booking_comment
      #
      # @param booking_comment [BookingSync::API::Resource|Integer] BookingComment
      #   or ID of the BookingComment to be updated.
      # @param options [Hash] BookingComment attributes to be updated.
      # @return [BookingSync::API::Resource] Updated BookingComment on success,
      #   exception is raised otherwise.
      # @example
      #   booking_comment = @api.booking_comments.first
      #   @api.edit_booking_comment(8, {conent: "New conent"})
      # => {:links=>{:booking=>1}, :id=>8, :content=>"New content", :editable=>true, :created_at=>2016-04-18 13:31:40 UTC, :updated_at=>2016-04-18 13:46:06 UTC}
      def edit_booking_comment(booking_comment, options = {})
        put("booking_comments/#{booking_comment}", booking_comments: [options]).pop
      end

      # Delete booking_comment
      #
      # @param booking_comment [BookingSync::API::Resource|Integer] BookingComment
      #   or ID of the BookingComment to be deleted.
      # @return [NilClass] Returns nil on success.
      def delete_booking_comment(booking_comment)
        delete "booking_comments/#{booking_comment}"
      end
    end
  end
end
