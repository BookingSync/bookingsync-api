module BookingSync::API
  class Client
    module Amenities
      # List amenities
      #
      # Returns amenities for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of amenities.
      #
      # @example Get the list of amenities for the current account
      #   amenities = @api.amenities
      #   amenities.first.title # => "Internet"
      # @example Get the list of amenities only with title and rental_id for smaller response
      #   @api.amenities(fields: [:title, :rental_id])
      # @see http://docs.api.bookingsync.com/reference/endpoints/amenities/#list-amenities
      def amenities(options = {}, &block)
        paginate :amenities, options, &block
      end
    end
  end
end
