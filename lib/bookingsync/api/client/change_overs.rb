module BookingSync::API
  class Client
    module ChangeOvers
      # List change_overs
      #
      # Returns change_overs for the rentals of the account, user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of change_overs.
      #
      # @example Get the list of change_overs for the current account
      #   change_overs = @api.change_overs
      #   change_overs.first.start_date # => "2014-05-30"
      # @see http://developers.bookingsync.com/reference/endpoints/change_overs/#list-change_overs
      def change_overs(options = {}, &block)
        paginate :change_overs, options, &block
      end

      # Get a single change_over
      #
      # @param change_over [BookingSync::API::Resource|Integer] ChangeOver or ID
      #   of the change_over.
      # @return [BookingSync::API::Resource]
      def change_over(change_over)
        get("change_overs/#{change_over}").pop
      end
    end
  end
end
