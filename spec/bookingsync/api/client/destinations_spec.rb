require "spec_helper"

describe BookingSync::API::Client::Destinations do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".destinations", :vcr do
    it "returns destinations" do
      expect(client.destinations).not_to be_empty
      assert_requested :get, bs_url("destinations")
    end
  end

  describe ".destination", :vcr do
    let(:prefetched_destination_id) {
      find_resource("#{@casette_base_path}_destinations/returns_destinations.yml", "destinations")[:id]
    }

    it "returns a single destination" do
      destination = client.destination(prefetched_destination_id)
      expect(destination.id).to eq prefetched_destination_id
    end
  end
end
