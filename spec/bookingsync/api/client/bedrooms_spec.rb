require "spec_helper"

describe BookingSync::API::Client::Bedrooms do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".bedrooms", :vcr do
    it "returns bedrooms" do
      expect(client.bedrooms).not_to be_empty
      assert_requested :get, bs_url("bedrooms")
    end
  end

  describe ".bedroom", :vcr do
    it "returns a single bedroom" do
      bedroom = client.bedroom(945)
      expect(bedroom.id).to eq 945
    end
  end

  describe ".create_bedroom", :vcr do
    let(:attributes) do
      {
        name_en: "New bedroom",
        sofa_beds_count: 2
      }
    end
    let(:rental) { BookingSync::API::Resource.new(client, id: 5116) }

    it "creates a new bedroom" do
      client.create_bedroom(rental, attributes)
      assert_requested :post, bs_url("rentals/5116/bedrooms"),
        body: { bedrooms: [attributes] }.to_json
    end

    it "returns newly created bedroom" do
      VCR.use_cassette("BookingSync_API_Client_Bedrooms/_create_bedroom/creates_a_new_bedroom") do
        bedroom = client.create_bedroom(rental, attributes)
        expect(bedroom.name).to eql(en: "New bedroom")
        expect(bedroom.sofa_beds_count).to eql(attributes[:sofa_beds_count])
      end
    end
  end

  describe ".edit_bedroom", :vcr do
    let(:attributes) {
      { name_en: "Updated bedroom" }
    }

    it "updates given bedroom by ID" do
      client.edit_bedroom(944, attributes)
      assert_requested :put, bs_url("bedrooms/944"),
        body: { bedrooms: [attributes] }.to_json
    end

    it "returns updated bedroom" do
      VCR.use_cassette("BookingSync_API_Client_Bedrooms/_edit_bedroom/updates_given_bedroom_by_ID") do
        bedroom = client.edit_bedroom(944, attributes)
        expect(bedroom).to be_kind_of(BookingSync::API::Resource)
        expect(bedroom.name).to eq(en: "Updated bedroom", fr: "Chambre 1")
      end
    end
  end

  describe ".cancel_bedroom", :vcr do
    it "cancels given bedroom" do
      client.cancel_bedroom(944)
      assert_requested :delete, bs_url("bedrooms/944")
    end
  end
end
