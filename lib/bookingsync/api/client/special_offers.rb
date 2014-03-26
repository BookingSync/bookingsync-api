module BookingSync::API
  class Client
    module SpecialOffers
      # List special_offers
      #
      # Returns special_offers for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of special_offers.
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

      # Create a new special_offer
      #
      # @param rental_id [Integer] ID of the rental
      # @param options [Hash] special_offer attributes
      # @return <BookingSync::API::Resource> Newly created special offer
      def create_special_offer(rental_id, options = {})
        post(:special_offers, rental_id: rental_id, special_offers: [options]).pop
      end

      # Edit a special_offer
      #
      # @param special_offer [BookingSync::API::Resource|Integer] special offer or
      # ID of the special offer to be updated
      # @param options [Hash] special offer attributes to be updated
      # @return [BookingSync::API::Resource] Updated special offer on success,
      # exception is raised otherwise
      # @example
      #   special_offer = @api.special_offers.first
      #   @api.edit_special_offer(special_offer, { name: "New offer" })
      def edit_special_offer(special_offer, options = {})
        put("special_offers/#{special_offer}", special_offers: [options]).pop
      end

      # Delete a special_offer
      #
      # @param special_offer [BookingSync::API::Resource|Integer] special offer or
      # ID of the special offer to be deleted
      # @return [Array] An empty Array on success, exception is raised otherwise
      def delete_special_offer(special_offer, options = {})
        delete "special_offers/#{special_offer}"
      end
    end
  end
end
