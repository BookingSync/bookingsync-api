module BookingSync::API
  class Client
    module Hosts
      # List hosts
      #
      # Returns all hosts supported in BookingSync.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of hosts.
      #
      # @example Get the list of hosts for the current account
      #   hosts = @api.hosts
      #   hosts.first.email # => "host_email@example.com"
      # @see http://developers.bookingsync.com/reference/endpoints/hosts/#list-hosts
      def hosts(options = {}, &block)
        paginate :hosts, options, &block
      end

      # Get a single host
      #
      # @param host [BookingSync::API::Resource|Integer] Host or ID
      #   of the host.
      # @return [BookingSync::API::Resource]
      def host(host)
        get("hosts/#{host}").pop
      end

      # Create a new host
      #
      # @param options [Hash] Host's attributes.
      # @return [BookingSync::API::Resource] Newly created host.
      def create_host(options = {})
        post(:hosts, hosts: [options]).pop
      end

      # Edit a host
      #
      # @param host [BookingSync::API::Resource|Integer] Host or ID of
      #   the host to be updated.
      # @param options [Hash] Host attributes to be updated.
      # @return [BookingSync::API::Resource] Updated host on success,
      #   exception is raised otherwise.
      # @example
      #   host = @api.hosts.first
      #   @api.edit_host(host, { firstname: "Johnny" })
      def edit_host(host, options = {})
        put("hosts/#{host}", hosts: [options]).pop
      end
    end
  end
end
