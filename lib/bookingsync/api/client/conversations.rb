module BookingSync::API
  class Client
    module Conversations
      # List conversations
      #
      # Returns all conversations supported in BookingSync.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of conversations.
      #
      # @example Get the list of conversations for the current account
      #   conversations = @api.conversations
      #   conversations.first.subject # => "Question"
      # @see http://developers.bookingsync.com/reference/endpoints/conversations/#list-conversations
      def conversations(options = {}, &block)
        paginate :conversations, options, &block
      end

      # Get a single conversation
      #
      # @param conversation [BookingSync::API::Resource|Integer] Conversation or ID
      #   of the conversation.
      # @return [BookingSync::API::Resource]
      def conversation(conversation)
        get("conversations/#{conversation}").pop
      end

      # Create a new conversation
      #
      # @param assignee [BookingSync::API::Resource|Integer] User object or ID
      #   for which assignee conversation will be created.
      # @param source [BookingSync::API::Resource] Source object or ID
      #   for which source conversation will be created.
      # @param options [Hash] Conversation's attributes.
      # @return [BookingSync::API::Resource] Newly created conversation.
      def create_conversation(assignee, source, options = {})
        post(:conversations, conversations: [
          options.merge(assignee_id: assignee.id, source_id: source.id)
        ]).pop
      end

      # Edit a conversation
      #
      # @param conversation [BookingSync::API::Resource|Integer] Conversation or ID of
      #   the conversation to be updated.
      # @param options [Hash] Conversation attributes to be updated.
      # @return [BookingSync::API::Resource] Updated conversation on success,
      #   exception is raised otherwise.
      # @example
      #   conversation = @api.conversations.first
      #   @api.edit_conversation(conversation, { closed: true })
      def edit_conversation(conversation, assignee, options = {})
        put("conversations/#{conversation}", conversations: [options.merge(assignee_id: assignee.id)]).pop
      end
    end
  end
end
