module BookingSync::API
  class Client
    module Rentals
      # List rentals
      #
      # Returns rentals for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<Sawyer::Resource>] List of rentals.
      #
      # @example Get the list of rentals for the current account
      #   rentals = @api.rentals
      #   rentals.first.name # => "Small apartment"
      # @example Get the list of rentals only with name and description for smaller response
      #   @api.rentals(fields: [:name, :description])
      def rentals(options = {})
        get :rentals, options
      end
    end
  end
end
