require "spec_helper"

describe BookingSync::API::Client::RentalsAmenities do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

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
    let(:prefetched_rentals_amenity_id) {
      find_resource("#{@casette_base_path}_rentals_amenities/returns_rentals_amenities.yml", "rentals_amenities")[:id]
    }

    it "returns rentals_amenity" do
      client.rentals_amenity(prefetched_rentals_amenity_id)
      assert_requested :get, bs_url("rentals_amenities/#{prefetched_rentals_amenity_id}")
    end
  end

  describe ".create_rentals_amenity", :vcr do
    let(:attributes) { { amenity_id: 48, details_en: "Details" } }
    let(:rental) { BookingSync::API::Resource.new(client, id: 5116) }

    it "creates a new rentals_amenity" do
      client.create_rentals_amenity(rental, attributes)
      assert_requested :post, bs_url("rentals/#{rental}/rentals_amenities"),
        body: { rentals_amenities: [attributes] }.to_json
    end

    it "returns newly created rentals_amenity" do
      VCR.use_cassette("BookingSync_API_Client_RentalsAmenities/_create_rentals_amenity/creates_a_new_rentals_amenity") do
        rentals_amenity = client.create_rentals_amenity(rental, attributes)
        expect(rentals_amenity.details).to eq(en: "Details")
      end
    end
  end

  describe ".edit_rentals_amenity", :vcr do
    let(:attributes) { { details_en: "New Details" } }
    let(:created_rentals_amenity_id) {
      find_resource("#{@casette_base_path}_create_rentals_amenity/creates_a_new_rentals_amenity.yml", "rentals_amenities")[:id]
    }

    it "updates given rentals_amenity by ID" do
      client.edit_rentals_amenity(created_rentals_amenity_id, attributes)
      assert_requested :put, bs_url("rentals_amenities/#{created_rentals_amenity_id}"),
        body: { rentals_amenities: [attributes] }.to_json
    end

    it "returns updated rentals_amenity" do
      VCR.use_cassette("BookingSync_API_Client_RentalsAmenities/_edit_rentals_amenity/updates_given_rentals_amenity_by_ID") do
        rentals_amenity = client.edit_rentals_amenity(created_rentals_amenity_id, attributes)
        expect(rentals_amenity).to be_kind_of(BookingSync::API::Resource)
        expect(rentals_amenity.details).to eq(en: "New Details")
      end
    end
  end

  describe ".delete_rentals_amenity", :vcr do
    let(:created_rentals_amenity_id) {
      find_resource("#{@casette_base_path}_create_rentals_amenity/creates_a_new_rentals_amenity.yml", "rentals_amenities")[:id]
    }

    it "deletes given rentals_amenity" do
      client.delete_rentals_amenity(created_rentals_amenity_id)
      assert_requested :delete, bs_url("rentals_amenities/#{created_rentals_amenity_id}")
    end
  end
end
