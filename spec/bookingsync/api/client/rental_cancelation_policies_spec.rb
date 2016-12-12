require "spec_helper"

describe BookingSync::API::Client::RentalCancelationPolicies do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".rental_cancelation_policies", :vcr do
    it "returns rental cancelation policies" do
      expect(client.rental_cancelation_policies).not_to be_empty
      assert_requested :get, bs_url("rental_cancelation_policies")
    end
  end

  describe ".rental_cancelation_policy", :vcr do
    let(:prefetched_rental_cancelation_policy_id) {
      find_resource("#{@casette_base_path}_rental_cancelation_policies/returns_rental_cancelation_policies.yml",
        "rental_cancelation_policies")[:id]
    }

    it "returns a single rental cancelation policy" do
      expect(client.rental_cancelation_policy(prefetched_rental_cancelation_policy_id).body).to eq "```body```"
    end
  end
end
