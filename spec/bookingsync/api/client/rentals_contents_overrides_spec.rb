require "spec_helper"

describe BookingSync::API::Client::RentalsContentsOverrides do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".rentals_contents_overrides", :vcr do
    it "returns rentals contents overrides" do
      expect(client.rentals_contents_overrides).not_to be_empty
      assert_requested :get, bs_url("rentals_contents_overrides")
    end

    describe "links" do
      it "returns associated rental" do
        rentals_contents_override = client.rentals_contents_overrides.first
        expect(rentals_contents_override.rental).not_to be_empty
      end
    end
  end

  describe ".rentals_contents_override", :vcr do
    let(:prefetched_rentals_contents_override_id) {
      find_resource("#{@casette_base_path}_rentals_contents_overrides/returns_rentals_contents_overrides.yml", "rentals_contents_overrides")[:id]
    }

    it "returns rentals_contents_override" do
      client.rentals_contents_override(prefetched_rentals_contents_override_id)
      assert_requested :get, bs_url("rentals_contents_overrides/#{prefetched_rentals_contents_override_id}")
    end
  end

  describe ".create_rentals_contents_override", :vcr do
    let(:attributes) { { summary_en: "english summary" } }
    let(:application) { BookingSync::API::Resource.new(client, id: 65) }
    let(:rental) { BookingSync::API::Resource.new(client, id: 5116) }

    it "creates a new rentals_contents_override" do
      client.create_rentals_contents_override(application, rental, attributes)
      assert_requested :post, bs_url("rentals_contents_overrides"),
        body: { rentals_contents_overrides: [attributes.merge(application_id: application.id, rental_id: rental.id)] }.to_json
    end

    it "returns newly created rentals_contents_override" do
      VCR.use_cassette("BookingSync_API_Client_RentalsContentsOverrides/_create_rentals_contents_override/creates_a_new_rentals_contents_override") do
        rentals_contents_override = client.create_rentals_contents_override(application, rental, attributes)
        expect(rentals_contents_override.summary).to eq(en: "english summary")
      end
    end
  end

  describe ".edit_rentals_contents_override", :vcr do
    let(:attributes) { { summary_en: "new english summary" } }
    let(:created_rentals_contents_override_id) {
      find_resource("#{@casette_base_path}_create_rentals_contents_override/creates_a_new_rentals_contents_override.yml", "rentals_contents_overrides")[:id]
    }

    it "updates given rentals_contents_override by ID" do
      client.edit_rentals_contents_override(created_rentals_contents_override_id, attributes)
      assert_requested :put, bs_url("rentals_contents_overrides/#{created_rentals_contents_override_id}"),
        body: { rentals_contents_overrides: [attributes] }.to_json
    end

    it "returns updated rentals_contents_override" do
      VCR.use_cassette("BookingSync_API_Client_RentalsContentsOverrides/_edit_rentals_contents_override/updates_given_rentals_contents_override_by_ID") do
        rentals_contents_override = client.edit_rentals_contents_override(created_rentals_contents_override_id, attributes)
        expect(rentals_contents_override).to be_kind_of(BookingSync::API::Resource)
        expect(rentals_contents_override.summary).to eq(en: "new english summary" )
      end
    end
  end

  describe ".delete_rentals_contents_override", :vcr do
    let(:created_rentals_contents_override_id) {
      find_resource("#{@casette_base_path}_create_rentals_contents_override/creates_a_new_rentals_contents_override.yml", "rentals_contents_overrides")[:id]
    }

    it "deletes given rentals_contents_override" do
      client.delete_rentals_contents_override(created_rentals_contents_override_id)
      assert_requested :delete, bs_url("rentals_contents_overrides/#{created_rentals_contents_override_id}")
    end
  end
end
