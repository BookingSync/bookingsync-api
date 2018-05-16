module BookingSync::API
  class Client
    module Attachments
      # List attachments
      #
      # Returns attachments for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of attachments.
      #
      # @example Get the list of attachments for the current account
      #   attachments = @api.attachments
      #   attachments.first.name # => "test.jpg"
      # @see http://developers.bookingsync.com/reference/endpoints/attachments/#list-attachments
      def attachments(options = {}, &block)
        paginate "inbox/attachments", options, &block
      end

      # Get a single attachment
      #
      # @param attachment [BookingSync::API::Resource|Integer] Attachment or ID
      #   of the attachment.
      # @return [BookingSync::API::Resource]
      def attachment(attachment)
        get("inbox/attachments/#{attachment}").pop
      end

      # Create a new attachment
      #
      # @param options [Hash] Attachment's attributes.
      # @return [BookingSync::API::Resource] Newly created attachment.
      def create_attachment(options = {})
        if file_path = options.delete(:file_path)
          options[:file] ||= base_64_encode(file_path)
        end
        post("inbox/attachments", attachments: [options]).pop
      end

      # Edit a attachment
      #
      # @param attachment [BookingSync::API::Resource|Integer] Attachment or ID of
      #   the attachment to be updated.
      # @param options [Hash] Attachment attributes to be updated.
      # @return [BookingSync::API::Resource] Updated attachment on success,
      #   exception is raised otherwise.
      # @example
      #   attachment = @api.attachments.first
      #   @api.edit_attachment(attachment, { name: "test.jpg" })
      def edit_attachment(attachment, options = {})
        if file_path = options.delete(:file_path)
          options[:file] ||= base_64_encode(file_path)
        end
        put("inbox/attachments/#{attachment}", attachments: [options]).pop
      end

      private

      def base_64_encode(file_path)
        Base64.encode64(File.read(file_path))
      end
    end
  end
end
