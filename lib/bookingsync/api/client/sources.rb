module BookingSync::API
  class Client
    module  Sources
      # List sources
      #
      # Returns sources for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of sources.
      #
      # @example Get the list of sources for the current account
      #   sources = @api.sources
      #   sources.first.name # => "HomeAway.com"
      # @example Get the list of sources only with name and account_id for smaller response
      #   @api.sources(fields: [:name, :account_id])
      # @see http://developers.bookingsync.com/reference/endpoints/sources/#list-sources
      def sources(options = {}, &block)
        paginate :sources, options, &block
      end

      # Get a single source
      #
      # @param source [BookingSync::API::Resource|Integer] Source or ID
      #   of the source.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def source(source, options = {})
        get("sources/#{source}", options).pop
      end

      # Create a new source
      #
      # @param options [Hash] source attributes
      # @return [BookingSync::API::Resource] Newly created source
      def create_source(options = {})
        post(:sources, sources: [options]).pop
      end

      # Edit a source
      #
      # @param source [BookingSync::API::Resource|Integer] source or
      # ID of the source to be updated
      # @param options [Hash] source attributes to be updated
      # @return [BookingSync::API::Resource] Updated source on success,
      # exception is raised otherwise
      # @example
      #   source = @api.sources.first
      #   @api.edit_source(source, { name: "Lorem" })
      def edit_source(source, options = {})
        put("sources/#{source}", sources: [options]).pop
      end
    end
  end
end
