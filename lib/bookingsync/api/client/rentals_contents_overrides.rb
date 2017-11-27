module BookingSync::API
  class Client
    module RentalsContentsOverrides
      # List rentals_contents_overrides
      #
      # Returns all rentals contents overrides for the current account.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of rentals_contents_overrides.
      #
      # @example Get the list of rentals contents overrides for the current account
      #   rentals_contents_overrides = @api.rentals_contents_overrides
      #   rentals_contents_overrides.first.description.en # => "Overriden English description"
      # @see http://developers.bookingsync.com/reference/endpoints/rentals_contents_overrides/#list-rentals-contents-overrides
      def rentals_contents_overrides(options = {}, &block)
        paginate :rentals_contents_overrides, options, &block
      end

      # Get a single rentals_contents_override
      #
      # @param rentals_contents_override [BookingSync::API::Resource|Integer]
      # rentals_contents_override or ID of the rentals_contents_override.
      # @return [BookingSync::API::Resource]
      # @see http://developers.bookingsync.com/reference/endpoints/rentals_contents_overrides/#get-a-single-rentals-content-override
      def rentals_contents_override(rentals_content_override)
        get("rentals_contents_overrides/#{rentals_content_override}").pop
      end

      # Create a rentals_contents_override
      #
      # @param application [BookingSync::API::Resource|Integer] Application object or ID
      #   for which the rentals contents override will be created.
      # @param rental [BookingSync::API::Resource|Integer] Rental object or ID
      #   for which the rentals contents override will be created.
      # @param options [Hash] Rentals Contents Override attributes.
      # @return [BookingSync::API::Resource] Newly created Rentals Contents Override.
      # @example Create a rentals contents override.
      #   @api.create_rentals_contents_override(1,, 12 { description_en: "Overriden English description" })
      # Overrides rental's (with id 12) description in English only for application with id 1.
      # @see http://developers.bookingsync.com/reference/endpoints/rentals_contents_overrides/#create-a-new-rentals-content-override
      def create_rentals_contents_override(application, rental, options = {})
        post("rentals_contents_overrides", rentals_contents_overrides: [
          options.merge(application_id: application.to_s.to_i, rental_id: rental.to_s.to_i)
        ]).pop
      end

      # Edit a rentals_contents_override
      #
      # @param rentals_contents_override [BookingSync::API::Resource|Integer] RentalsContentsOverride or ID of
      #   the rentals_contents_override to be updated.
      # @param options [Hash] rentals_contents_override attributes to be updated.
      # @return [BookingSync::API::Resource] Updated rentals_contents_override on success,
      #   exception is raised otherwise.
      # @example
      #   rentals_contents_override = @api.rentals_contents_overrides.first
      #   @api.edit_rentals_contents_override(rentals_contents_override, { summary_en: "Override English summary" })
      # @see http://developers.bookingsync.com/reference/endpoints/rentals_contents_overrides/#update-a-rentals-content-override
      def edit_rentals_contents_override(rentals_contents_override, options = {})
        put("rentals_contents_overrides/#{rentals_contents_override}", rentals_contents_overrides: [options]).pop
      end

      # Delete a rentals_contents_override
      #
      # @param rentals_contents_override [BookingSync::API::Resource|Integer] RentalsContentsOverride or ID
      #   of the rentals_contents_override to be deleted.
      # @return [NilClass] Returns nil on success.
      def delete_rentals_contents_override(rentals_contents_override)
        delete "rentals_contents_overrides/#{rentals_contents_override}"
      end
    end
  end
end
