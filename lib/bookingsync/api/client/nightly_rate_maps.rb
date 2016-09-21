module BookingSync::API
  class Client
    module NightlyRateMaps
      # List nightly_rate_maps
      #
      # Returns nightly_rate_maps for the rentals of the account, user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of nightly_rate_maps.
      #
      # @example Get the list of nightly_rate_maps for the current account
      #   nightly_rate_maps = @api.nightly_rate_maps
      #   nightly_rate_maps.first.start_date # => "2014-05-30"
      # @see http://developers.bookingsync.com/reference/endpoints/nightly_rate_maps/#list-nightly-rate-maps
      def nightly_rate_maps(options = {}, &block)
        paginate :nightly_rate_maps, options, &block
      end

      # Get a single nightly_rate_map
      #
      # @param nightly_rate_map [BookingSync::API::Resource|Integer] NightlyRateMap or ID
      #   of the nightly_rate_map.
      # @return [BookingSync::API::Resource]
      def nightly_rate_map(nightly_rate_map)
        get("nightly_rate_maps/#{nightly_rate_map}").pop
      end

      # Edit a nightly_rate_map
      #
      # @param nightly_rate_map [BookingSync::API::Resource|Integer] NightlyRateMap or ID of
      #   the nightly_rate_map to be updated.
      # @param options [Hash] NightlyRateMap attributes to be updated.
      # @return [BookingSync::API::Resource] Updated nightly_rate_map on success,
      #   exception is raised otherwise.
      # @example
      #   nightly_rate_map = @api.nightly_rate_maps.first
      #   @api.edit_nightly_rate_map(nightly_rate_map, { rates_map: "10,10,10,0..." })
      def edit_nightly_rate_map(nightly_rate_map, options = {})
        put("nightly_rate_maps/#{nightly_rate_map}", nightly_rate_maps: [options]).pop
      end
    end
  end
end
