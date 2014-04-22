require "spec_helper"

describe BookingSync::API::Client::BillingAddresses do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".billing_addresses", :vcr do
    it "returns billing_addresses" do
      expect(client.billing_addresses).not_to be_nil
      assert_requested :get, bs_url("billing_addresses")
    end
  end
end
