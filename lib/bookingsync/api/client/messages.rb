module BookingSync::API
  class Client
    module Messages
      # List messages
      #
      # Returns all messages supported in BookingSync.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of messages.
      #
      # @example Get the list of messages for the current account
      #   messages = @api.messages
      #   messages.first.content # => "Message content"
      # @see http://developers.bookingsync.com/reference/endpoints/messages/#list-messages
      def messages(options = {}, &block)
        paginate "inbox/messages", options, &block
      end

      # Get a single message
      #
      # @param message [BookingSync::API::Resource|Integer] Message or ID
      #   of the message.
      # @return [BookingSync::API::Resource]
      def message(message)
        get("inbox/messages/#{message}").pop
      end

      # Create a new message
      #
      # @param options [Hash] Message's attributes.
      # @return [BookingSync::API::Resource] Newly created message.
      def create_message(options = {})
        post("inbox/messages", messages: [options]).pop
      end

      # Edit a message
      #
      # @param message [BookingSync::API::Resource|Integer] Message or ID of
      #   the message to be updated.
      # @param options [Hash] Message attributes to be updated.
      # @return [BookingSync::API::Resource] Updated message on success,
      #   exception is raised otherwise.
      # @example
      #   message = @api.messages.first
      #   @api.edit_message(message, { content: "Updated message content" })
      def edit_message(message, options = {})
        put("inbox/messages/#{message}", messages: [options]).pop
      end

      # Add attachment to message
      # @param message [BookingSync::API::Resource|Integer] Message or ID of
      #   the message to which we are adding attachment
      # @param options [Hash] Id of attachment to be added to message.
      # @return [BookingSync::API::Resource] Message with updated links on success,
      #   exception is raised otherwise.
      # @example
      #   @api.add_attachment_to_message(message, { id: 5 })
      def add_attachment_to_message(message, options)
        put("inbox/messages/#{message}/add_attachment", attachments: [options]).pop
      end
    end
  end
end
