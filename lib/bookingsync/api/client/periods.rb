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
    end
  end
end
