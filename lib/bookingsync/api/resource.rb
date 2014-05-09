require "hashie"

module BookingSync::API
  class Resource < Hash
    include Hashie::Extensions::MethodAccess
    attr_reader :_client, :_rels, :_links, :_resources_key

    # Initialize a Resource with the given links and data.
    #
    # @param client [BookingSync::API::Client] The client that made the API request.
    # @param data [Hash] Hash of key/value properties.
    # @param links [Hash] Hash of link templates for this resource.
    # @param resources_key [Symbol|String] Key in response body under which
    def initialize(client, data = {}, links = {}, resources_key = nil)
      @_links = links
      @_client = client
      @_resources_key = resources_key
      data.each do |key, value|
        self[key.to_sym] = process_value(value)
      end
      @_rels = Relation.from_links(client, links)
    end

    # Process an individual value of this resource. Hashes get exploded
    # into another Resource, and Arrays get their values processed too.
    #
    # @param value [Object] An Object value of a Resource's data.
    # @return [Object] An Object to set as the value of a Resource key.
    def process_value(value)
      case value
      when Hash  then self.class.new(@_client, value, @_links)
      when Array then value.map { |v| process_value(v) }
      else value
      end
    end

    # Make associations accessible
    #
    # @param method [Symbol] Name of association
    # @param args [Array] Array of additional arguments
    def method_missing(method, *args)
      association_key = :"#{@_resources_key}.#{method}"
      if self[:links] && self[:links].has_key?(method)
        ids = Array(self[:links][method])
        return [] if ids.empty?
        options = {uri: {association_key => ids}}
        options.merge!(query: args.first) if args.first.is_a?(Hash)
        @_rels[association_key].get(options).resources
      else
        super
      end
    end

    def to_s
      id.to_s
    end
  end
end
