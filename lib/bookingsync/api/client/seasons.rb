module BookingSync::API
  class Client
    module Seasons
      # List seasons
      #
      # Returns seasons for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of seasons.
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
      # @param rates_table_id [BookingSync::API::Resource|Integer] Rates table
      #   or ID of the rates table for which a season will be created.
      # @param options [Hash] Season's attributes.
      # @return [BookingSync::API::Resource] Newly created season.
      def create_season(rates_table, options = {})
        post("rates_tables/#{rates_table}/seasons", seasons: [options]).pop
      end

      # Edit a season
      #
      # @param season [BookingSync::API::Resource|Integer] Season or ID of
      #   the season to be updated.
      # @param options [Hash] Season attributes to be updated.
      # @return [BookingSync::API::Resource] Updated season on success,
      #   exception is raised otherwise.
      # @example
      #   season = @api.seasons.first
      #   @api.edit_season(season, { name: "Some season" })
      def edit_season(season, options = {})
        put("seasons/#{season}", seasons: [options]).pop
      end

      # Delete a season
      #
      # @param season [BookingSync::API::Resource|Integer] Season or ID
      #   of the season to be deleted.
      # @return [NilClass] Returns nil on success.
      def delete_season(season)
        delete "seasons/#{season}"
      end
    end
  end
end
