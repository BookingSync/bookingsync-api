module BookingSync::API
  class Client
    module Seasons 
      # List seasons
      #
      # Returns seasons for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<Sawyer::Resource>] Array of seasons.
      #
      # @example Get the list of seasons for the current account
      #   seasons = @api.seasons
      #   seasons.first.name # => "Season 2"
      # @example Get the list of seasons only with name and ratio for smaller response
      #   @api.seasons(fields: [:name, :ratio])
      # @see http://docs.api.bookingsync.com/reference/endpoints/seasons/#list-seasons
      def seasons(options = {}, &block)
        paginate :seasons, options, &block
      end
    end
  end
end
