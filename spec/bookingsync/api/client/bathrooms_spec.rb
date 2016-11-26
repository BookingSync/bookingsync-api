require "spec_helper"

describe BookingSync::API::Client::Bathrooms do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".bathrooms", :vcr do
    it "returns bathrooms" do
      expect(client.bathrooms).not_to be_empty
      assert_requested :get, bs_url("bathrooms")
    end
  end

  describe ".bathroom", :vcr do
    it "returns a single bathroom" do
      bathroom = client.bathroom(730)
      expect(bathroom.id).to eq 730
    end
  end

  describe ".create_bathroom", :vcr do
    let(:attributes) do
      {
        name_en: "New bathroom",
        wc: true
      }
    end
    let(:rental) { BookingSync::API::Resource.new(client, id: 5116) }

    it "creates a new bathroom" do
      client.create_bathroom(rental, attributes)
      assert_requested :post, bs_url("rentals/5116/bathrooms"),
        body: { bathrooms: [attributes] }.to_json
    end

    it "returns newly created bathroom" do
      VCR.use_cassette("BookingSync_API_Client_Bathrooms/_create_bathroom/creates_a_new_bathroom") do
        bathroom = client.create_bathroom(rental, attributes)
        expect(bathroom.name).to eql(en: "New bathroom")
        expect(bathroom.wc).to eql(attributes[:wc])
      end
    end
  end

  describe ".edit_bathroom", :vcr do
    let(:attributes) {
      { name_en: "Updated bathroom" }
    }

    it "updates given bathroom by ID" do
      client.edit_bathroom(729, attributes)
      assert_requested :put, bs_url("bathrooms/729"),
        body: { bathrooms: [attributes] }.to_json
    end

    it "returns updated bathroom" do
      VCR.use_cassette("BookingSync_API_Client_Bathrooms/_edit_bathroom/updates_given_bathroom_by_ID") do
        bathroom = client.edit_bathroom(729, attributes)
        expect(bathroom).to be_kind_of(BookingSync::API::Resource)
        expect(bathroom.name).to eq(en: "Updated bathroom", fr: "Salle de bain 1")
      end
    end
  end

  describe ".cancel_bathroom", :vcr do
    it "cancels given bathroom" do
      client.cancel_bathroom(729)
      assert_requested :delete, bs_url("bathrooms/729")
    end
  end
end
