module BookingSync::API
  class Client
    module BookingsTags
      # List bookings tags
      #
      # Returns bookings tags for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of bookings tags.
      #
      # @example Get the list of bookings tags for the current account
      #   bookings_tags = @api.bookings_tags
      #   bookings_tags.first.color # => "#6666ff"
      # @example Get the list of bookings tags only with color for smaller response
      #   @api.bookings_tags(fields: [:color])
      # @see http://developers.bookingsync.com/reference/endpoints/bookings_tags/#list-bookings-tags
      def bookings_tags(options = {}, &block)
        paginate :bookings_tags, options, &block
      end

      # Get a single bookings tag
      #
      # @param bookings_tag [BookingSync::API::Resource|Integer] BookingsTag or ID
      #   of the bookings tag.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def bookings_tag(bookings_tag, options = {})
        get("bookings_tags/#{bookings_tag}", options).pop
      end
    end
  end
end
