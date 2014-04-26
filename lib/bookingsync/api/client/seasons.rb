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

      # Create a new season
      #
      # @param rates_table_id [Integer] ID of the rates table
      # @param options [Hash] season attributes
      # @return <Sawyer::Resource> Newly created season
      def create_season(rates_table_id, options = {})
        post(:seasons, rates_table_id: rates_table_id, seasons: [options]).pop
      end

      # Edit a season
      #
      # @param season [Sawyer::Resource|Integer] season or ID of the season
      # to be updated
      # @param options [Hash] season attributes to be updated
      # @return [Sawyer::Resource] Updated season on success, exception is raised otherwise
      # @example
      #   season = @api.seasons.first
      #   @api.edit_season(season, { name: "Some season" }) => Sawyer::Resource
      def edit_season(season, options = {})
        put("seasons/#{season}", seasons: [options]).pop
      end

      # Delete a season
      #
      # @param season [Sawyer::Resource|Integer] season or ID of the season
      # to be deleted
      # @return [Array] An empty Array on success, exception is raised otherwise
      def delete_season(season, options = {})
        delete "seasons/#{season}"
      end
    end
  end
end
