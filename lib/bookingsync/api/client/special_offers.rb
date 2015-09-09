module BookingSync::API
  class Client
    module SpecialOffers
      # List special_offers
      #
      # Returns special offers for the account user is authenticated with.
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

      # Get a single special_offer
      #
      # @param special_offer [BookingSync::API::Resource|Integer] SpecialOffer or ID
      #   of the special_offer.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def special_offer(special_offer, options = {})
        get("special_offers/#{special_offer}", options).pop
      end

      # Create a new special offer for a rental
      #
      # @param rental [BookingSync::API::Resource|Integer] Rental or ID of the
      #   rental for which special offer will be created.
      # @param options [Hash] Special offer's attributes.
      # @return [BookingSync::API::Resource] Newly created special offer.
      def create_special_offer(rental, options = {})
        post("rentals/#{rental}/special_offers", special_offers: [options]).pop
      end

      # Edit a special offer
      #
      # @param special_offer [BookingSync::API::Resource|Integer] Special offer
      #   or ID of the special offer to be updated.
      # @param options [Hash] special offer attributes to be updated.
      # @return [BookingSync::API::Resource] Updated special offer on success,
      #   exception is raised otherwise.
      # @example
      #   special_offer = @api.special_offers.first
      #   @api.edit_special_offer(special_offer, {name: "New offer"})
      def edit_special_offer(special_offer, options = {})
        put("special_offers/#{special_offer}", special_offers: [options]).pop
      end

      # Delete a special offer
      #
      # @param special_offer [BookingSync::API::Resource|Integer] Special offer
      #   or ID of the special offer to be deleted.
      # @return [NilClass] Returns nil on success.
      def delete_special_offer(special_offer)
        delete "special_offers/#{special_offer}"
      end
    end
  end
end
