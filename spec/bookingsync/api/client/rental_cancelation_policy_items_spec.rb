require "spec_helper"

describe BookingSync::API::Client::RentalCancelationPolicyItems do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".rental_cancelation_policy_items", :vcr do
    it "returns rental cancelation policy items" do
      expect(client.rental_cancelation_policy_items).not_to be_empty
      assert_requested :get, bs_url("rental_cancelation_policy_items")
    end
  end

  describe ".rental_cancelation_policy_item", :vcr do
    let(:prefetched_rental_cancelation_policy_item_id) {
      find_resource("#{@casette_base_path}_rental_cancelation_policy_items/returns_rental_cancelation_policy_items.yml",
        "rental_cancelation_policy_items")[:id]
    }

    it "returns a single rental cancelation policy item" do
      expect(client.rental_cancelation_policy_item(prefetched_rental_cancelation_policy_item_id).penalty_percentage).to eq "20.0"
    end
  end
end
