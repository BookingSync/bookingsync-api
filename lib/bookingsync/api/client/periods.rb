module BookingSync::API
  class Client
    module Periods
      # List periods
      #
      # Returns periods for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<Sawyer::Resource>] Array of periods.
      #
      # @example Get the list of periods for the current account
      #   periods = @api.periods
      #   periods.first.start_at # => "2014-04-11"
      # @example Get the list of periods only with start_at and end_at for smaller response
      #   @api.periods(fields: [:start_at, :end_at])
      # @see http://docs.api.bookingsync.com/reference/endpoints/periods/#list-periods
      def periods(options = {}, &block)
        paginate :periods, options, &block
      end

      # Create a new period
      #
      # @param season_id [Integer] ID of the season
      # @param options [Hash] period attributes
      # @return <Sawyer::Resource> Newly created period
      def create_period(season_id, options = {})
        post(:periods, season_id: season_id, periods: [options]).pop
      end

      # Edit a period
      #
      # @param period [Sawyer::Resource|Integer] period or ID of the period
      # to be updated
      # @param options [Hash] period attributes to be updated
      # @return [Sawyer::Resource] Updated period on success,
      # exception is raised otherwise
      # @example
      #   period = @api.periods.first
      #   @api.edit_period(period, { end_at: "2014-04-28" }) => Sawyer::Resource
      def edit_period(period, options = {})
        put("periods/#{period}", periods: [options]).pop
      end

      # Delete a period
      #
      # @param period [Sawyer::Resource|Integer] period or ID of the period
      # to be deleted
      # @return [Array] An empty Array on success, exception is raised otherwise
      def delete_period(period, options = {})
        delete "periods/#{period}"
      end
    end
  end
end
