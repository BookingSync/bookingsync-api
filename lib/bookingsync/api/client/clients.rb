module BookingSync::API
  class Client
    module Clients
      # List clients
      #
      # Returns clients for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<Sawyer::Resource>] Array of clients.
      #
      # @example Get the list of clients for the current account
      #   clients = @api.clients
      #   clients.first.fullname # => "John Smith"
      # @example Get the list of clients only with name and fullname for smaller response
      #   @api.clients(fields: [:fullname, :phone])
      # @see http://docs.api.bookingsync.com/reference/endpoints/clients/#list-clients
      def clients(options = {}, &block)
        paginate :clients, options, &block
      end
    end
	end
end
