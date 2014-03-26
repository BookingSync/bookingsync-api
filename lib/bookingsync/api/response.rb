require "addressable/template"

module BookingSync::API
  class Response
    SPECIAL_JSONAPI_FIELDS = %w(links linked meta)
    attr_reader :client, :status, :headers, :data, :rels, :body

    # Build a Response after a completed request.
    #
    # @param client [BookingSync::API::Client] The client that is
    #   managing the API connection.
    # @param res [Faraday::Response] Faraday response object
    def initialize(client, res)
      @client  = client
      @status  = res.status
      @headers = res.headers
      @env     = res.env
      @body    = res.body
    end

    # Turn parsed contents from an API response into a Resource or
    # collection of Resources.
    #
    # @param hash [Hash] A Hash of resources parsed from JSON.
    # @return [Array] An Array of Resources.
    def process_data(hash, links)
      Array(hash).map do |hash|
        Resource.new(client, hash, links, resources_key)
      end
    end

    # Return name of the key in the response body hash
    # where fetched resources are, like bookings or rentals
    #
    # @return [Symbol] Key name in the body hash
    def resources_key
      decoded_body.keys.delete_if { |k|
        SPECIAL_JSONAPI_FIELDS.include?(k)
      }.pop
    end

    # Return an array of Resources from the response body
    #
    # @return [Array<BookingSync::API::Resource>]
    def resources
      @resources ||= process_data(decoded_body[resources_key], links)
    end

    # Return an array of links templates from the response body,
    # it's the contents of links hash
    # {'links': {'rentals.photos':'https://www.bookingsync.com/api/v3/photos/{rentals.photos}'}}
    #
    # @return [Hash] Hash of links to associated resources
    def links
      @links ||= decoded_body[:links]
    end

    # Return link relations from 'Link' response header
    #
    # @return [Array] An array of Relations
    def rels
      @rels ||= process_rels
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
