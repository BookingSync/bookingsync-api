module BookingSync::API
  class Client
    module Availabilities
      # List availabilities
      #
      # Returns availabilities for the rentals of the account, user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of availabilities.
      #
      # @example Get the list of availabilities for the current account
      #   availabilities = @api.availabilities
      #   availabilities.first.start_date # => "2014-05-30"
      # @see http://docs.api.bookingsync.com/reference/endpoints/availabilities/#list-availabilities
      def availabilities(options = {}, &block)
        paginate :availabilities, options, &block
      end
    end
  end
end
