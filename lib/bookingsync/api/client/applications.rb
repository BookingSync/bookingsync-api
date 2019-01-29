module BookingSync::API
  class Client
    module Applications
      # List applications
      #
      # Returns all applications supported in BookingSync.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of applications.
      #
      # @example Get the list of applications for the current account
      #   applications = @api.applications
      #   applications.first.title # => "Internet"
      # @see http://developers.bookingsync.com/reference/endpoints/applications/#list-applications
      def applications(options = {}, &block)
        paginate :applications, options, &block
      end

      # Get a single application
      #
      # @param application [BookingSync::API::Resource|Integer] application or ID
      #   of the application.
      # @return [BookingSync::API::Resource]
      # @see http://developers.bookingsync.com/reference/endpoints/applications/#get-a-single-application
      def application(application)
        get("applications/#{application}").pop
      end

      # Edit an application
      #
      # @param application [BookingSync::API::Resource|Integer] application or ID of the application
      # to be updated
      # @param options [Hash] application attributes to be updated
      # @return [BookingSync::API::Resource] Updated application on success, exception is raised otherwise
      # @example
      #   application = @api.applications.first
      #   @api.edit_application(application, { default_price_increase: 3 })
      def edit_application(application, options = {})
        put("applications/#{application}", applications: [options]).pop
      end    
    end
  end
end
