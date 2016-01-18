require "spec_helper"

describe BookingSync::API::Client::RentalCancelationPolicyItems do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".rental_cancelation_policy_items", :vcr do
    it "returns rental cancelation policy items" do
      expect(client.rental_cancelation_policy_items).not_to be_empty
      assert_requested :get, bs_url("rental_cancelation_policy_items")
    end
  end

  describe ".rental_cancelation_policy_item", :vcr do
    it "returns a single rental cancelation policy item" do
      expect(client.rental_cancelation_policy_item(13).penalty_percentage).to eq "20.0"
    end
  end
end
