module BookingSync::API
  class Client
    module PreferencesGeneralSettings
      # List preferences general settings
      #
      # Returns preferences general settings for the account user is authenticated with.
      # @param options [Hash] A customizable set of options.
      # @option options [Array] fields: List of fields to be fetched.
      # @return [Array<BookingSync::API::Resource>] Array of preferences general settings.
      #
      # @example Get the list of preferences general settings for the current account
      #   preferences_general_settings = @api.preferences_general_settings
      #   preferences_general_settings.first.email # => "test@example.com"
      # @example Get the list of preferences general settings only with email for smaller response
      #   @api.preferences_general_settings(fields: [:email])
      def preferences_general_settings(options = {}, &block)
        paginate :preferences_general_settings, options, &block
      end

      # Edit a preferences general setting
      #
      # @param preferences_general_setting [BookingSync::API::Resource|Integer]
      #   PreferencesGeneralSetting or ID of the preferences_general_setting to be updated
      # @param options [Hash] preferences_general_setting attributes to be updated
      # @return [BookingSync::API::Resource] Updated preferences_general_setting on success,
      #   exception is raised otherwise
      # @example
      #   preferences_general_setting = @api.preferences_general_settings.first
      #   @api.edit_preferences_general_setting(preferences_general_setting, { selected_locales: ["fr"] })
      def edit_preferences_general_setting(preferences_general_setting, options = {})
        put("preferences_general_settings/#{preferences_general_setting}",
          preferences_general_settings: [options]).pop
      end
    end
  end
end
