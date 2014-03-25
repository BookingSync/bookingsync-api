module BookingSync::API
  class Client
    module Inquiries
      # List inquiries
      #
      # Return list of inquiries for current account.
      # @param options [Hash] A customizable set of query options.
      # @return [Array<Sawyer::Resource>] Array of inquiries.
      # @see http://docs.api.bookingsync.com/reference/endpoints/inquiries/#list-inquiries
      def inquiries(options = {}, &block)
        paginate :inquiries, options, &block
      end

      # Create a new inquiry
      #
      # @param options [Hash] Inquiry attributes
      # @return <Sawyer::Resource> Newly create inquiry
      def create_inquiry(options = {})
        post(:inquiries, inquiries: [options]).pop
      end
    end
  end
end
