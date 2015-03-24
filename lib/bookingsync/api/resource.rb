require "hashie"

module BookingSync::API
  class Resource < Hash
    include Hashie::Extensions::MethodAccess
    attr_reader :_client, :_rels, :_resources_key

    # Initialize a Resource with the given relations and data.
    #
    # @param client [BookingSync::API::Client] The client that made the API request.
    # @param data [Hash] Hash of key/value properties.
    # @param rels [Hash] Hash of built relations for this resource.
    # @param resources_key [Symbol|String] Key in response body under which
    def initialize(client, data = {}, rels = {}, resources_key = nil)
      @_client = client
      @_resources_key = resources_key
      data.each do |key, value|
        self[key.to_sym] = process_value(value)
      end
      @_rels = rels
    end

    # Process an individual value of this resource. Hashes get exploded
    # into another Resource, and Arrays get their values processed too.
    #
    # @param value [Object] An Object value of a Resource's data.
    # @return [Object] An Object to set as the value of a Resource key.
    def process_value(value)
      case value
      when Hash  then self.class.new(@_client, value)
      when Array then value.map { |v| process_value(v) }
      else value
      end
    end

    # Make associations accessible
    #
    # @param method [Symbol] Name of association
    # @param args [Array] Array of additional arguments
    def method_missing(method, *args)
      return self[method] if has_key?(method) # eager loaded with :include
      association_key = :"#{@_resources_key}.#{method}"
      if (polymorphic_association = find_polymorphic_association(self[:links], method))
        attributes = polymorphic_association.last
        ids, type = Array(attributes[:id]), attributes[:type]
        resolved_association_key = :"#{@_resources_key}.#{type.downcase}"
        uri_association_key = "#{association_key}.id"

        extract_resources(ids, resolved_association_key, uri_association_key, *args)
      elsif self[:links] && self[:links].has_key?(method)
        ids = Array(self[:links][method])
        extract_resources(ids, association_key, association_key, *args)
      else
        super
      end
    end

    def to_s
      id.to_s
    end

    private

    # links structure: {:taggable=>{:type=>"Article", :id=>"15"}}
    def find_polymorphic_association(links, method)
      links.select { |_, data| data.is_a?(Hash) }
        .find { |assoc, _| assoc.to_s.downcase == method.to_s.downcase }
    end

    def extract_resources(ids, association_key, uri_association_key, *args)
      return [] if ids.empty?
      options = {uri: {uri_association_key => ids}}
      options.merge!(query: args.first) if args.first.is_a?(Hash)
      @_rels[association_key].get(options).resources
    end
  end
end
