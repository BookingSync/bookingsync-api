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

  describe ".create_rentals_amenity", :vcr do
    let(:attributes) { { amenity_id: 44, details_en: "Details" } }
    let(:rental) { BookingSync::API::Resource.new(client, id: 5116) }

    it "creates a new rentals_amenity" do
      client.create_rentals_amenity(rental, attributes)
      assert_requested :post, bs_url("rentals/5116/rentals_amenities"),
        body: { rentals_amenities: [attributes] }.to_json
    end

    it "returns newly created rentals_amenity" do
      VCR.use_cassette('BookingSync_API_Client_RentalsAmenities/_create_rentals_amenity/creates_a_new_rentals_amenity') do
        rentals_amenity = client.create_rentals_amenity(rental, attributes)
        expect(rentals_amenity.details).to eq({ en: "Details" })
      end
    end
  end

  describe ".edit_rentals_amenity", :vcr do
    let(:attributes) { { details_en: "New Details" } }

    it "updates given rentals_amenity by ID" do
      client.edit_rentals_amenity(6159, attributes)
      assert_requested :put, bs_url("rentals_amenities/6159"),
        body: { rentals_amenities: [attributes] }.to_json
    end

    it "returns updated rentals_amenity" do
      VCR.use_cassette('BookingSync_API_Client_RentalsAmenities/_edit_rentals_amenity/updates_given_rentals_amenity_by_ID') do
        rentals_amenity = client.edit_rentals_amenity(6159, attributes)
        expect(rentals_amenity).to be_kind_of(BookingSync::API::Resource)
        expect(rentals_amenity.details).to eq({ en: "New Details" })
      end
    end
  end

  describe ".delete_rentals_amenity", :vcr do
    it "deletes given rentals_amenity" do
      client.delete_rentals_amenity(32833)
      assert_requested :delete, bs_url("rentals_amenities/32833")
    end
  end
end
