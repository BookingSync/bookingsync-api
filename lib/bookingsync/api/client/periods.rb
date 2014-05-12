module BookingSync::API
  class Client
    module Periods
      # List periods
      #
      # Returns periods for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of periods.
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
      # @param season [BookingSync::API::Resource|Integer] Season or ID of
      #   the season for which period will be created.
      # @param options [Hash] Period's attributes.
      # @return [BookingSync::API::Resource] Newly created period.
      def create_period(season, options = {})
        post("seasons/#{season}/periods", periods: [options]).pop
      end

      # Edit a period
      #
      # @param period [BookingSync::API::Resource|Integer] Period or ID of
      #   the period to be updated.
      # @param options [Hash] period attributes to be updated.
      # @return [BookingSync::API::Resource] Updated period on success,
      #   exception is raised otherwise.
      # @example
      #   period = @api.periods.first
      #   @api.edit_period(period, { end_at: "2014-04-28" })
      def edit_period(period, options = {})
        put("periods/#{period}", periods: [options]).pop
      end

      # Delete a period
      #
      # @param period [BookingSync::API::Resource|Integer] Period or ID
      #   of the period to be deleted.
      # @return [NilClass] Returns nil on success.
      def delete_period(period)
        delete "periods/#{period}"
      end
    end
  end
end
