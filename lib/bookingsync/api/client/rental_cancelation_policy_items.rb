module BookingSync::API
  class Client
    module RentalCancelationPolicyItems
      # List rental cancelation policy items.
      #
      # Returns rental cancelation policy items for the rentals of the account
      # and account itself user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of rental cancelation policy items.
      #
      # @example Get the list of rental cancelation policy items for the current account
      #   item = @api.rental_cancelation_policy_items
      #   item.first.eligible_days # => 10
      # @example Get the list of rental cancelation policy items only with eligible_days for smaller response
      #   @api.rental_cancelation_policy_items(fields: :eligible_days)
      # @see http://docs.api.bookingsync.com/reference/endpoints/rental_cancelation_policy_items/#list-rental_cancelation_policy_items
      def rental_cancelation_policy_items(options = {}, &block)
        paginate :rental_cancelation_policy_items, options, &block
      end

      # Get a single rental cancelation policy item
      #
      # @param rental_cancelation_policy_item [BookingSync::API::Resource|Integer] RentalCancelationPolicyItem or ID
      #   of the rental cancelation policy item.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def rental_cancelation_policy_item(rental_cancelation_policy_item, options = {})
        get("rental_cancelation_policy_items/#{rental_cancelation_policy_item}", options).pop
      end
    end
  end
end
