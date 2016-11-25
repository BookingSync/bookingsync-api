require "spec_helper"

describe BookingSync::API::Client::PreferencesPayments do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".preferences_payments", :vcr do
    it "returns preferences payments" do
      expect(client.preferences_payments).not_to be_empty
      assert_requested :get, bs_url("preferences_payments")
    end
  end
end
