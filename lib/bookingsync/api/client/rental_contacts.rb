module BookingSync::API
  class Client
    module RentalContacts
      # List rental_contacts
      #
      # Returns all rantal_contacts related to rentals for the current account.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of rental_contacts.
      #
      # @example Get the list of contacts for the current account
      #   rental_contacts = @api.rental_contacts
      #   rental_contacts.first.contact.title # => "Internet"
      # @see http://developers.bookingsync.com/reference/endpoints/rental_contacts/#list-rentals-contacts
      def rental_contacts(options = {}, &block)
        paginate :rental_contacts, options, &block
      end

      # Get a single rental_contact
      #
      # @param rental_contact [BookingSync::API::Resource|Integer]
      # rental_contact or ID of the rental_contact.
      # @return [BookingSync::API::Resource]
      def rental_contact(rental_contact)
        get("rental_contacts/#{rental_contact}").pop
      end

      # Create a rental's contact
      #
      # @param rental [BookingSync::API::Resource|Integer] Rental object or ID
      #   for which the rental contact will be created.
      # @param options [Hash] Rental Amenity' s attributes.
      # @return [BookingSync::API::Resource] Newly created rental's contact.
      # @example Create a rental's contact.
      #   @api.create_rental_contact(10, { contact_id: 50 }) # Add the Internet contact to the rental with ID 10
      # @see http://developers.bookingsync.com/reference/endpoints/rental_contacts/#create-a-new-rentals-contact
      def create_rental_contact(rental, options = {})
        post("rentals/#{rental}/rental_contacts", rental_contacts: [options]).pop
      end

      # Edit a rental_contact
      #
      # @param rental_contact [BookingSync::API::Resource|Integer] RentalsAmenity or ID of
      #   the rental_contact to be updated.
      # @param options [Hash] rental_contact attributes to be updated.
      # @return [BookingSync::API::Resource] Updated rental_contact on success,
      #   exception is raised otherwise.
      # @example
      #   rental_contact = @api.rental_contacts.first
      #   @api.edit_rental_contact(rental_contact, { details_en: "Details" })
      def edit_rental_contact(rental_contact, options = {})
        put("rental_contacts/#{rental_contact}", rental_contacts: [options]).pop
      end

      # Delete a rental_contact
      #
      # @param rental_contact [BookingSync::API::Resource|Integer] RentalsAmenity or ID
      #   of the rental_contact to be deleted.
      # @return [NilClass] Returns nil on success.
      def delete_rental_contact(rental_contact)
        delete "rental_contacts/#{rental_contact}"
      end
    end
  end
end
