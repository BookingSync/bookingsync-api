module BookingSync::API
  class Client
    module RentalCancelationPolicies
      # List rental cancelation policies.
      #
      # Returns rental cancelation policies for the rentals of the account
      # and account itself user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of rental cancelation policies.
      #
      # @example Get the list of rental cancelation policies for the current account
      #   policy = @api.rental_cancelation_policies
      #   policy.first.body # => "My rental cancelation policy"
      # @example Get the list of rental cancelation policies only with body for smaller response
      #   @api.rental_cancelation_policies(fields: :body)
      # @see http://docs.api.bookingsync.com/reference/endpoints/rental_cancelation_policies/#list-rental_cancelation_policies
      def rental_cancelation_policies(options = {}, &block)
        paginate :rental_cancelation_policies, options, &block
      end

      # Get a single rental cancelation policy
      #
      # @param rental_cancelation_policy [BookingSync::API::Resource|Integer] RentalCancelationPolicy or ID
      #   of the rental cancelation policy.
      # @param options [Hash] A customizable set of query options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [BookingSync::API::Resource]
      def rental_cancelation_policy(rental_cancelation_policy, options = {})
        get("rental_cancelation_policies/#{rental_cancelation_policy}", options).pop
      end
    end
  end
end
