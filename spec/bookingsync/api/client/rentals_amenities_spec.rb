require "spec_helper"

describe BookingSync::API::Client::RentalsAmenities do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".rentals_amenities", :vcr do
    it "returns rentals amenities" do
      expect(client.rentals_amenities).not_to be_empty
      assert_requested :get, bs_url("rentals_amenities")
    end

    describe "links" do
      it "returns associated rental" do
        rentals_amenity = client.rentals_amenities.first
        expect(rentals_amenity.rental).not_to be_empty
      end

      it "returns associated amenity" do
        rentals_amenity = client.rentals_amenities.first
        expect(rentals_amenity.amenity).not_to be_empty
      end
    end
  end

  describe ".rentals_amenity", :vcr do
    it "returns rentals_amenity" do
      amenity = client.rentals_amenity(1)
      assert_requested :get, bs_url("rentals_amenities/1")
    end
  end
end
