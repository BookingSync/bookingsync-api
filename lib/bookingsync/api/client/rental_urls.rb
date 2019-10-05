module BookingSync::API
  class Client
    module RentalUrls
      # List rental_urls
      #
      # Returns rental_urls for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of rental_urls.
      #
      # @example Get the list of rental_urls for the current account
      #   rental_urls = @api.rental_urls
      #   rental_urls.first.name # => "test.jpg"
      # @see http://developers.bookingsync.com/reference/endpoints/rental_urls/#list-rental_urls
      def rental_urls(options = {}, &block)
        paginate :rental_urls, options, &block
      end

      # Get a single rental_url
      #
      # @param rental_url [BookingSync::API::Resource|Integer] RentalUrl or ID
      #   of the rental_url.
      # @return [BookingSync::API::Resource]
      def rental_url(rental_url)
        get("rental_urls/#{rental_url}").pop
      end

      # Create a new rental_url
      #
      # @param options [Hash] RentalUrl's attributes.
      # @return [BookingSync::API::Resource] Newly created rental_url.
      def create_rental_url(rental, options = {})
        if file_path = options.delete(:file_path)
          options[:file] ||= base_64_encode(file_path)
        end
        post("rentals/#{rental}/rental_urls", rental_urls: options).pop
      end

      # Edit a rental_url
      #
      # @param rental_url [BookingSync::API::Resource|Integer] RentalUrl or ID of
      #   the rental_url to be updated.
      # @param options [Hash] RentalUrl attributes to be updated.
      # @return [BookingSync::API::Resource] Updated rental_url on success,
      #   exception is raised otherwise.
      # @example
      #   rental_url = @api.rental_urls.first
      #   @api.edit_rental_url(rental_url, { name: "test.jpg" })
      def edit_rental_url(rental_url, options = {})
        if file_path = options.delete(:file_path)
          options[:file] ||= base_64_encode(file_path)
        end
        put("rental_urls/#{rental_url}", rental_urls: options).pop
      end

      private

      def base_64_encode(file_path)
        Base64.encode64(File.read(file_path))
      end
    end
  end
end
