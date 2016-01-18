require "spec_helper"

describe BookingSync::API::Client::RentalCancelationPolicies do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".rental_cancelation_policies", :vcr do
    it "returns rental cancelation policies" do
      expect(client.rental_cancelation_policies).not_to be_empty
      assert_requested :get, bs_url("rental_cancelation_policies")
    end
  end

  describe ".rental_cancelation_policy", :vcr do
    it "returns a single rental cancelation policy" do
      expect(client.rental_cancelation_policy(13).body).to eq "``` body ``` "
    end
  end
end
