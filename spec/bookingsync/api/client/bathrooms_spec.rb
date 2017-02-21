require "spec_helper"

describe BookingSync::API::Client::Bathrooms do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".bathrooms", :vcr do
    it "returns bathrooms" do
      expect(client.bathrooms).not_to be_empty
      assert_requested :get, bs_url("bathrooms")
    end
  end

  describe ".bathroom", :vcr do
    let(:prefetched_bathroom_id) {
      find_resource("#{@casette_base_path}_bathrooms/returns_bathrooms.yml", "bathrooms")[:id]
    }

    it "returns a single bathroom" do
      bathroom = client.bathroom(prefetched_bathroom_id)
      expect(bathroom.id).to eq prefetched_bathroom_id
    end
  end

  describe ".create_bathroom", :vcr do
    let(:attributes) do
      {
        name_en: "New bathroom",
        wc_count: 2
      }
    end
    let(:rental) { BookingSync::API::Resource.new(client, id: 5116) }

    it "creates a new bathroom" do
      client.create_bathroom(rental, attributes)
      assert_requested :post, bs_url("rentals/#{rental}/bathrooms"),
        body: { bathrooms: [attributes] }.to_json
    end

    it "returns newly created bathroom" do
      VCR.use_cassette("BookingSync_API_Client_Bathrooms/_create_bathroom/creates_a_new_bathroom") do
        bathroom = client.create_bathroom(rental, attributes)
        expect(bathroom.name).to eq(en: "New bathroom")
        expect(bathroom.wc_count).to eq(attributes[:wc_count])
      end
    end
  end

  describe ".edit_bathroom", :vcr do
    let(:attributes) {
      { name_en: "Updated bathroom", name_fr: "Salle de bain 1" }
    }
    let(:created_bathroom_id) {
      find_resource("#{@casette_base_path}_create_bathroom/creates_a_new_bathroom.yml", "bathrooms")[:id]
    }

    it "updates given bathroom by ID" do
      client.edit_bathroom(created_bathroom_id, attributes)
      assert_requested :put, bs_url("bathrooms/#{created_bathroom_id}"),
        body: { bathrooms: [attributes] }.to_json
    end

    it "returns updated bathroom" do
      VCR.use_cassette("BookingSync_API_Client_Bathrooms/_edit_bathroom/updates_given_bathroom_by_ID") do
        bathroom = client.edit_bathroom(created_bathroom_id, attributes)
        expect(bathroom).to be_kind_of(BookingSync::API::Resource)
        expect(bathroom.name).to eq(en: "Updated bathroom", fr: "Salle de bain 1")
      end
    end
  end

  describe ".cancel_bathroom", :vcr do
    let(:created_bathroom_id) {
      find_resource("#{@casette_base_path}_create_bathroom/creates_a_new_bathroom.yml", "bathrooms")[:id]
    }

    it "cancels given bathroom" do
      client.cancel_bathroom(created_bathroom_id)
      assert_requested :delete, bs_url("bathrooms/#{created_bathroom_id}")
    end
  end
end
