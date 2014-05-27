require "spec_helper"

describe BookingSync::API::Client::Amenities do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".amenities", :vcr do
    it "returns amenities" do
      expect(client.amenities).not_to be_empty
      assert_requested :get, bs_url("amenities")
    end
  end

  describe ".amenity", :vcr do
    it "returns amenity" do
      amenity = client.amenity(2)
      expect(amenity.title).to eql("tv")
    end
  end
end
