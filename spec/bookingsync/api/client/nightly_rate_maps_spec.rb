require "spec_helper"

describe BookingSync::API::Client::NightlyRateMaps do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".nightly_rate_maps", :vcr do
    it "returns nightly_rate_maps" do
      expect(client.nightly_rate_maps).not_to be_empty
      assert_requested :get, bs_url("nightly_rate_maps")
    end
  end

  describe ".nightly_rate_map", :vcr do
    let(:prefetched_nightly_rate_map_id) {
      find_resource("#{@casette_base_path}_nightly_rate_maps/returns_nightly_rate_maps.yml", "nightly_rate_maps")[:id]
    }

    it "returns a single nightly_rate_map" do
      nightly_rate_map = client.nightly_rate_map(prefetched_nightly_rate_map_id)
      expect(nightly_rate_map.id).to eq prefetched_nightly_rate_map_id
    end
  end

  describe ".edit_nightly_rate_map", :vcr do
    let(:attributes) { { rates_map: (["10"] * 1096).join(","), start_date: "2016-12-11" } }
    let(:prefetched_nightly_rate_map_id) {
      find_resource("#{@casette_base_path}_nightly_rate_maps/returns_nightly_rate_maps.yml", "nightly_rate_maps")[:id]
    }

    it "updates given nightly_rate_map by ID" do
      client.edit_nightly_rate_map(prefetched_nightly_rate_map_id, attributes)
      assert_requested :put, bs_url("nightly_rate_maps/#{prefetched_nightly_rate_map_id}"),
        body: { nightly_rate_maps: [attributes] }.to_json
    end

    it "returns updated nightly_rate_map" do
      VCR.use_cassette("BookingSync_API_Client_NightlyRateMaps/_edit_nightly_rate_map/updates_given_nightly_rate_map_by_ID") do
        nightly_rate_map = client.edit_nightly_rate_map(prefetched_nightly_rate_map_id, attributes)
        expect(nightly_rate_map).to be_kind_of(BookingSync::API::Resource)
        expect(nightly_rate_map.rates_map).to eq attributes[:rates_map]
      end
    end
  end
end
