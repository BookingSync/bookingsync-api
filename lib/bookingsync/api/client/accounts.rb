module BookingSync::API
  class Client
    module Accounts
      # List accounts
      #
      # Returns all the accounts that the user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of accounts.
      #
      # @example Get the list of accounts for the current account
      #   accounts = @api.accounts
      #   accounts.first.email # => "user@example.com"
      # @see http://docs.api.bookingsync.com/reference/endpoints/accounts/#list-accounts
      def accounts(options = {}, &block)
        paginate :accounts, options, &block
      end
    end
  end
end
