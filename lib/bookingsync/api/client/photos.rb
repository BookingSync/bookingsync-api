module BookingSync::API
  class Client
    module Photos
      # List photos
      #
      # Returns photos for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<Sawyer::Resource>] Array of photos.
      #
      # @example Get the list of photos for the current account
      #   photos = @api.photos
      #   photos.first.position # => 1
      # @example Get the list of photos only with medium_url and position for smaller response
      #   @api.photos(fields: [:medium_url, :position])
      # @see http://docs.api.bookingsync.com/reference/endpoints/photos/#list-photos
      def photos(options = {}, &block)
        paginate :photos, options, &block
      end
    end
  end
end
