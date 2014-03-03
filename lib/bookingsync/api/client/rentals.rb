module BookingSync::API
  class Client
    module Rentals
      # List rentals
      #
      # Returns rentals for the account user is authenticated with
      # @return [Array<Sawyer::Resource>] list of rentals
      #
      # @example Get the list of rentals for the current account
      #   rentals = @api.rentals
      #   rentals.first.name # => "Small apartment"
      def rentals
        get :rentals
      end
    end
  end
end
