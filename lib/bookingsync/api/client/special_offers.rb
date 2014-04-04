module BookingSync::API
  class Client
    module SpecialOffers
      # List special_offers
      #
      # Returns special_offers for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<Sawyer::Resource>] Array of special_offers.
      #
      # @example Get the list of special_offers for the current account
      #   special_offers = @api.special_offers
      #   special_offers.first.name # => "Spring discount"
      # @example Get the list of special_offers only with name and rental_id for smaller response
      #   @api.special_offers(fields: [:name, :rental_id])
      # @see http://docs.api.bookingsync.com/reference/endpoints/special_offers/#list-special_offers
      def special_offers(options = {}, &block)
        paginate :special_offers, options, &block
      end
    end
  end
end
