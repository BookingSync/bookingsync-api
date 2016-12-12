module BookingSync::API
  class ExconResponse
    SPECIAL_JSONAPI_FIELDS = [:links, :linked, :meta]
    attr_reader :client, :status, :headers, :data, :relations, :body

    # Build a Response after a completed request.
    #
    # @param client [BookingSync::API::Client] The client that is
    #   managing the API connection.
    # @param res [Faraday::Response] Faraday response object
    def initialize(client, res)
      @client  = client
      @status  = res.status
      @headers = res.headers
      @body    = res.body
    end

    # Turn parsed contents from an API response into a Resource or
    # collection of Resources.
    #
    # @param hash [Hash] A Hash of resources parsed from JSON.
    # @return [Array] An Array of Resources.
    def process_data(hash)
      Array(hash).map do |hash|
        Resource.new(client, hash, resource_relations, resources_key)
      end
    end

    # Return name of the key in the response body hash
    # where fetched resources are, like bookings or rentals
    #
    # @return [Symbol] Key name in the body hash
    def resources_key
      decoded_body.keys.delete_if { |key|
        SPECIAL_JSONAPI_FIELDS.include?(key)
      }.pop
    end

    # Return an array of Resources from the response body
    #
    # @return [Array<BookingSync::API::Resource>]
    def resources
      @resources ||= process_data(decoded_body[resources_key])
    end

    # Returns a Hash of relations built from given links templates.
    # These relations are the same for each resource, so we calculate
    # them once here and pass to every top level resource.
    #
    # @return [Hash] Hash of relations to associated resources
    def resource_relations
      @resource_relations ||= Relation.from_links(client,
        decoded_body[:links])
    end

    # Return a Hash of relations to other pages built from 'Link'
    # response header
    #
    # @return [Hash] Hash of relations to first, last, next and prev pages
    def relations
      @relations ||= process_rels
    end

    # Returns a Hash of meta information taken from the response body
    #
    # @return [Hash] Meta hash
    def meta
      @meta ||= decoded_body[:meta]
    end

    private

    def decoded_body
      @decoded_body ||= @client.decode_body(body) || {}
    end

    def process_rels
      links = ( @headers["Link"] || "" ).split(', ').map do |link|
        href, name = link.match(/<(.*?)>; rel="(\w+)"/).captures
        [name.to_sym, Relation.from_link(@client, name, :href => href)]
      end
      Hash[*links.flatten]
    end
  end
end
