module BookingSync::API
  class Client
    module Contacts
      # List contacts
      #
      # Returns contacts for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of contacts.
      #
      # @example Get the list of contacts for the current account
      #   contacts = @api.contacts
      #   contacts.first.fullname # => "John Smith"
      # @example Get the list of contacts only with fullname and phone for smaller response
      #   @api.contacts(fields: [:fullname, :phone])
      # @see http://developers.bookingsync.com/reference/endpoints/contacts/#list-contacts
      def contacts(options = {}, &block)
        paginate :contacts, options, &block
      end

      # Get a single contact
      #
      # @param contact [BookingSync::API::Resource|Integer] Contact or ID
      #   of the contact.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def contact(contact, options = {})
        get("contacts/#{contact}", options).pop
      end

      # Create a new contact
      #
      # @param options [Hash] Contact attributes
      # @return [BookingSync::API::Resource] Newly created contact
      def create_contact(options = {})
        post(:contacts, contacts: [options]).pop
      end

      # Edit a contact
      #
      # @param contact [BookingSync::API::Resource|Integer] Contact or ID of the contact
      #   to be updated
      # @param options [Hash] Contact attributes to be updated
      # @return [BookingSync::API::Resource] Updated contact on success, exception is raised otherwise
      # @example
      #   contact = @api.contacts.first
      #   @api.edit_contact(contact, { fullname: "Gary Smith" })
      def edit_contact(contact, options = {})
        put("contacts/#{contact}", contacts: [options]).pop
      end

      # Delete a contact
      #
      # @param contact [BookingSync::API::Resource|Integer] Contact or ID
      #   of the contact to be deleted.
      # @return [NilClass] Returns nil on success.
      def delete_contact(contact)
        delete "contacts/#{contact}"
      end
    end
  end
end
