module BookingSync::API
  class Client
    module Inquiries
      # List inquiries
      #
      # Return list of inquiries for current account.
      # @param options [Hash] A customizable set of query options.
      # @return [Array<BookingSync::API::Resource>] Array of inquiries.
      # @see http://docs.api.bookingsync.com/reference/endpoints/inquiries/#list-inquiries
      def inquiries(options = {}, &block)
        paginate :inquiries, options, &block
      end

      # Create a new inquiry
      #
      # @param rental [BookingSync::API::Resource] Rental or ID of the rental
      #   for which an inquiry will be created.
      # @param options [Hash] Inquiry attributes.
      # @return [BookingSync::API::Resource] Newly create inquiry.
      def create_inquiry(rental, options = {})
        post("rentals/#{rental}/inquiries", inquiries: [options]).pop
      end
    end
  end
end
