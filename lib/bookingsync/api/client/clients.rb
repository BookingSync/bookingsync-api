module BookingSync::API
  class Client
    module Clients
      # List clients
      #
      # Returns clients for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of clients.
      #
      # @example Get the list of clients for the current account
      #   clients = @api.clients
      #   clients.first.fullname # => "John Smith"
      # @example Get the list of clients only with fullname and phone for smaller response
      #   @api.clients(fields: [:fullname, :phone])
      # @see http://developers.bookingsync.com/reference/endpoints/clients/#list-clients
      def clients(options = {}, &block)
        paginate :clients, options, &block
      end

      # Get a single client
      #
      # @param client [BookingSync::API::Resource|Integer] Client or ID
      #   of the client.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def client(client, options = {})
        get("clients/#{client}", options).pop
      end

      # Create a new client
      #
      # @param options [Hash] Client attributes
      # @return [BookingSync::API::Resource] Newly created client
      def create_client(options = {})
        post(:clients, clients: [options]).pop
      end

      # Edit a client
      #
      # @param client [BookingSync::API::Resource|Integer] Client or ID of the client
      #   to be updated
      # @param options [Hash] Client attributes to be updated
      # @return [BookingSync::API::Resource] Updated client on success, exception is raised otherwise
      # @example
      #   client = @api.clients.first
      #   @api.edit_client(client, { fullname: "Gary Smith" })
      def edit_client(client, options = {})
        put("clients/#{client}", clients: [options]).pop
      end
    end
  end
end
