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
        paginate :messages, options, &block
      end

      # Get a single message
      #
      # @param message [BookingSync::API::Resource|Integer] Message or ID
      #   of the message.
      # @return [BookingSync::API::Resource]
      def message(message)
        get("messages/#{message}").pop
      end

      # Create a new message
      #
      # @param conversation [BookingSync::API::Resource|Integer] Conversation object or ID
      #   for which conversation message will be created.
      # @param participant [BookingSync::API::Resource|Integer] Participant object or ID
      #   for which participant message will be created.
      # @param options [Hash] Message's attributes.
      # @return [BookingSync::API::Resource] Newly created message.
      def create_message(conversation, participant, options = {})
        post(:messages, messages: [
          options.merge(conversation_id: conversation.id, participant_id: participant.id)
        ]).pop
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
        put("messages/#{message}", messages: [options]).pop
      end
    end
  end
end
