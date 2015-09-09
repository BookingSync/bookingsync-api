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

      # Get a single photo
      #
      # @param photo [BookingSync::API::Resource|Integer] Photo or ID
      #   of the photo.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def photo(photo, options = {})
        get("photos/#{photo}", options).pop
      end

      # Create a photo
      #
      # @param rental [BookingSync::API::Resource|Integer] Rental object or ID
      #   for which the photo will be created. Image can be provided in three
      #   ways, as a file path, encode string or as an URL.
      # @param options [Hash] Photo's attributes.
      # @option options [String] photo_path: Path to the image to be uploaded.
      # @option options [String] photo: Photo encoded with Base64
      # @option options [String] remote_photo_url: URL to a remote image which
      #   will be fetched and then saved
      # @return [BookingSync::API::Resource] Newly created photo.
      # @example Create a photo.
      #   @api.create_photo(10, photo_path: 'rentals/big_one.jpg')
      # @see http://docs.api.bookingsync.com/reference/endpoints/photos/#create-a-new-photo
      def create_photo(rental, options = {})
        if photo_path = options.delete(:photo_path)
          options[:photo] ||= encode(photo_path)
        end
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
        if photo_path = options.delete(:photo_path)
          options[:photo] ||= encode(photo_path)
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
