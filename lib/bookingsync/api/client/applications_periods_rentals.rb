module BookingSync::API
  class Client
    module ApplicationsPeriodsRentals
      # List applications_periods_rentals
      #
      # Returns all applications_periods_rentals supported in BookingSync.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of applications_periods_rentals.
      #
      # @example Get the list of applications_periods_rentals for the current account
      #   applications_periods_rentals = @api.applications_periods_rentals
      #   applications_periods_rentals.first.title # => "Internet"
      # @see http://developers.bookingsync.com/reference/endpoints/applications_periods_rentals/#list-applications_periods_rentals
      def applications_periods_rentals(options = {}, &block)
        paginate :applications_periods_rentals, options, &block
      end

      # Get a single applications_periods_rental
      #
      # @param applications_periods_rental [BookingSync::API::Resource|Integer] applications_periods_rental or ID
      #   of the applications_periods_rental.
      # @return [BookingSync::API::Resource]
      # @see http://developers.bookingsync.com/reference/endpoints/applications_periods_rentals/#get-a-single-applications-periods-rental
      def applications_periods_rental(applications_periods_rental)
        get("applications_periods_rentals/#{applications_periods_rental}").pop
      end

      # Edit an applications_periods_rental
      #
      # @param applications_periods_rental [BookingSync::API::Resource|Integer] applications_periods_rental or ID of the applications_periods_rental
      # to be updated
      # @param options [Hash] applications_periods_rental attributes to be updated
      # @return [BookingSync::API::Resource] Updated applications_periods_rental on success, exception is raised otherwise
      # @example
      #   applications_periods_rental = @api.applications_periods_rentals.first
      #   @api.edit_application(applications_periods_rental, { default_price_increase: 3 })
      def edit_applications_periods_rental(applications_periods_rental, options = {})
        put("applications_periods_rentals/#{applications_periods_rental}", applications_periods_rental: options).pop
      end
    end
  end
end
