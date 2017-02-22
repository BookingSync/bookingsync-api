require "spec_helper"

describe BookingSync::API::Client::Amenities do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".amenities", :vcr do
    it "returns amenities" do
      expect(client.amenities).not_to be_empty
      assert_requested :get, bs_url("amenities")
    end
  end

  describe ".amenity", :vcr do
    let(:prefetched_amenity) {
      find_resource("#{@casette_base_path}_amenities/returns_amenities.yml", "amenities")
    }

    it "returns amenity" do
      amenity = client.amenity(prefetched_amenity[:id])
      expect(amenity.title).to eq(prefetched_amenity[:title])
    end
  end
end
