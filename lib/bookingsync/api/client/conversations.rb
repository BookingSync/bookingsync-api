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
        paginate "inbox/conversations", options, &block
      end

      # Get a single conversation
      #
      # @param conversation [BookingSync::API::Resource|Integer] Conversation or ID
      #   of the conversation.
      # @return [BookingSync::API::Resource]
      def conversation(conversation)
        get("inbox/conversations/#{conversation}").pop
      end

      # Create a new conversation
      #
      # @param options [Hash] Conversation's attributes.
      # @return [BookingSync::API::Resource] Newly created conversation.
      def create_conversation(options = {})
        post("inbox/conversations", conversations: [options]).pop
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
      def edit_conversation(conversation, options = {})
        put("inbox/conversations/#{conversation}", conversations: [options]).pop
      end

      # Connect conversation with booking
      # @param conversation [BookingSync::API::Resource|Integer] Conversation or ID of
      #   the conversation to be connected to booking
      # @param options [Hash] Id of booking to be connected to conversation.
      # @return [BookingSync::API::Resource] Conversation with updated links on success,
      #   exception is raised otherwise.
      # @example
      #   @api.connect_booking_to_conversation(conversation, { id: 5 })
      def connect_booking_to_conversation(conversation, options)
        put("inbox/conversations/#{conversation}/connect_booking", bookings: [options]).pop
      end

      # Disconnect conversation from booking
      # @param conversation [BookingSync::API::Resource|Integer] Conversation or ID of
      #   the conversation connected to booking
      # @param options [Hash] Id of booking to be disconnected from conversation.
      # @return [BookingSync::API::Resource] Conversation with updated links on success,
      #   exception is raised otherwise.
      # @example
      #   @api.disconnect_booking_from_conversation(conversation, { id: 5 })
      def disconnect_booking_from_conversation(conversation, options)
        put("inbox/conversations/#{conversation}/disconnect_booking", bookings: [options]).pop
      end
    end
  end
end
