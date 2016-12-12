require "spec_helper"

describe BookingSync::API::Client::PreferencesGeneralSettings do
  let(:api) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".preferences_general_settings", :vcr do
    it "returns preferences_general_settings" do
      expect(api.preferences_general_settings).not_to be_empty
      assert_requested :get, bs_url("preferences_general_settings")
    end
  end

  describe ".edit_preferences_general_setting", :vcr do
    let(:prefetched_preferences_general_settings_id) {
      find_resource("#{@casette_base_path}_preferences_general_settings/returns_preferences_general_settings.yml",
        "preferences_general_settings")[:id]
    }

    it "updates given preferences_general_setting by ID" do
      api.edit_preferences_general_setting(prefetched_preferences_general_settings_id, selected_locales: ["de"])
      assert_requested :put, bs_url("preferences_general_settings/#{prefetched_preferences_general_settings_id}"),
        body: { preferences_general_settings: [{ selected_locales: ["de"] }] }.to_json
    end

    it "returns updated preferences_general_setting" do
      VCR.use_cassette("BookingSync_API_Client_PreferencesGeneralSettings/_edit_preferences_general_setting/updates_given_preferences_general_setting_by_ID") do
        setting = api.edit_preferences_general_setting(prefetched_preferences_general_settings_id, selected_locales: ["de"])
        expect(setting).to be_kind_of(BookingSync::API::Resource)
        expect(setting.selected_locales).to eq ["en", "fr", "de"]
      end
    end
  end
end
