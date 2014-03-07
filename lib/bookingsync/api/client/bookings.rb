module BookingSync::API
  class Client
    module Bookings
      # List bookings
      #
      # Return public future bookings for the account user is authenticated with
      # @return [Array<Sawyer::Resource>] list of bookings
      def bookings
        get :bookings
      end
    end
  end
end
