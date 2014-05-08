require "base64"

module BookingSync::API
  class Client
    module Photos
      # List photos
      #
      # Returns photos for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of photos.
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

      # Create a photo
      #
      # @param rental [BookingSync::API::Resource|Integer] Rental object or ID
      #   for which the photo will be created.
      # @param options [Hash] Photo's attributes.
      # @option options [String] file_path: Required file path to the image.
      # @return [BookingSync::API::Resource] Newly created photo.
      # @example Create a photo.
      #   @api.create_photo(10, file_path: 'rentals/big_one.jpg')
      # @see http://docs.api.bookingsync.com/reference/endpoints/photos/#create-a-new-photo
      def create_photo(rental, options = {})
        file_path = options.delete(:file_path)
        options[:photo] = encode(file_path)
        options[:filename] = File.basename(file_path)
        post("rentals/#{rental}/photos", photos: [options]).pop
      end

      # Edit a photo
      #
      # @param photo [BookingSync::API::Resource|Integer] Photo or ID of the
      #   photo to be updated.
      # @param options [Hash] Photo's attributes.
      # @return [BookingSync::API::Resource] Updated photo
      # @see http://docs.api.bookingsync.com/reference/endpoints/photos/#update-a-photo
      def edit_photo(photo, options = {})
        if file_path = options.delete(:file_path)
          options[:photo] = encode(file_path)
          options[:filename] = File.basename(file_path)
        end
        put("photos/#{photo}", photos: [options]).pop
      end

      # Delete a photo
      #
      # @param photo [BookingSync::API::Resource|Integer] Photo or ID of the
      #   photo to be deleted.
      # @return [NilClass] Returns nil on success.
      # @see http://docs.api.bookingsync.com/reference/endpoints/photos/#destroy-a-photo
      def delete_photo(photo)
        delete "photos/#{photo}"
      end

      private

      def encode(file_path)
        Base64.encode64(File.read(file_path))
      end
    end
  end
end
