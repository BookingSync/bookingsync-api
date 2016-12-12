require "spec_helper"

describe BookingSync::API::Client::ChangeOvers do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".change_overs", :vcr do
    it "returns change_overs" do
      expect(client.change_overs).not_to be_empty
      assert_requested :get, bs_url("change_overs")
    end
  end

  describe ".change_over", :vcr do
    let(:prefetched_change_over_id) {
      find_resource("#{@casette_base_path}_change_overs/returns_change_overs.yml", "change_overs")[:id]
    }

    it "returns a single change_over" do
      change_over = client.change_over(prefetched_change_over_id)
      expect(change_over.id).to eq prefetched_change_over_id
    end
  end
end
