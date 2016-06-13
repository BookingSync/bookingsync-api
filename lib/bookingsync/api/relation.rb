require "addressable/template"

module BookingSync::API
  class Relation
    attr_reader :client, :name, :href_template, :method

    # Build a hash of Relations from the `links` key in JSON API response.
    #
    # @param client [BookingSync::API::Client] The client that made the HTTP
    #   request.
    # @param links [Hash] Hash of relation_name => relation options.
    # @return [Hash] Hash of relation_name => relation elements.
    def self.from_links(client, links)
      relations = {}
      links.each do |name, options|
        relations[name] = from_link(client, name, options)
      end if links
      relations
    end

    # Build a single Relation from the given options.
    #
    # @param client [BookingSync::API::Client] The client that made the HTTP
    #   request
    #
    # @param name [Symbol] Name of the Relation.
    # @param options [Hash] A Hash containing the other Relation properties.
    # @option options [String] href: The String URL of the next action's location.
    # @option options [String] method: The optional String HTTP method.
    # @return [BookingSync::API::Relation] New relation
    def self.from_link(client, name, options)
      case options
      when Hash
        new client, name, options[:href], options[:method]
      when String
        new client, name, options
      end
    end

    # A Relation represents an available next action for a resource.
    #
    # @param client [BookingSync::API::Client] The client that made the HTTP
    #   request.
    # @param name [Symbol] The name of the relation.
    # @param href [String] The String URL of the location of the next action.
    # @param method [Symbol] The Symbol HTTP method. Default: :get
    def initialize(client, name, href, method = nil)
      @client = client
      @name = name.to_sym
      @href = href
      @href_template = ::Addressable::Template.new(href.to_s)
      @method = (method || :get).to_sym
      @available_methods = Set.new methods || [@method]
    end

    # Make an API request with the curent Relation using GET.
    #
    # @param options [Hash] Options to configure the API request.
    # @option options [Hash] headers: Hash of API headers to set.
    # @option options [Hash] query: Hash of URL query params to set.
    # @option options [Symbol] method: Symbol HTTP method.
    # @return [BookingSync::API::Response] A response
    def get(data = {})
      client.call :get, href_template, data, {}
    end

    # Make an API request with the curent Relation using POST.
    #
    # @param options [Hash] Options to configure the API request.
    # @option options [Hash] headers: Hash of API headers to set.
    # @option options [Hash] query: Hash of URL query params to set.
    # @option options [Symbol] method: Symbol HTTP method.
    # @return [BookingSync::API::Response] A response
    def post(data = {})
      client.call :post, href_template, data, {}
    end

    # Return expanded URL

    # @param options [Hash] Params to be included in expanded URL
    # @return [String] expanded URL

    def href(options = nil)
      return @href if @href_template.nil?
      @href_template.expand(options || {}).to_s
    end
  end
end
