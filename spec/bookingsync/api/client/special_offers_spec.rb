require "spec_helper"

describe BookingSync::API::Client::SpecialOffers do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".special_offers", :vcr do
    it "returns special_offers" do
      expect(client.special_offers).not_to be_empty
      assert_requested :get, bs_url("special_offers")
    end
  end

  describe ".create_special_offer", :vcr do
    let(:attributes) {
      {
        name: "New special offer",
        start_at: '2014-04-28',
        end_at: '2014-05-28',
        discount: 5
      }
    }
    let(:rental) { BookingSync::API::Resource.new(client, id: 12) }

    it "creates a new special_offer" do
      client.create_special_offer(rental, attributes)
      assert_requested :post, bs_url("rentals/12/special_offers"),
        body: {special_offers: [attributes]}.to_json
    end

    it "returns newly created special_offer" do
      VCR.use_cassette('BookingSync_API_Client_SpecialOffers/_create_special_offer/creates_a_new_special_offer') do
        special_offer = client.create_special_offer(rental, attributes)
        expect(special_offer.name).to eql(attributes[:name])
      end
    end
  end

  describe ".edit_special_offer", :vcr do
    let(:attributes) {
      { name: 'Updated special offer' }
    }

    it "updates given special_offer by ID" do
      client.edit_special_offer(3, attributes)
      assert_requested :put, bs_url("special_offers/3"),
        body: { special_offers: [attributes] }.to_json
    end

    it "returns updated special_offer" do
      VCR.use_cassette('BookingSync_API_Client_SpecialOffers/_edit_special_offer/updates_given_special_offer_by_ID') do
        special_offer = client.edit_special_offer(3, attributes)
        expect(special_offer).to be_kind_of(BookingSync::API::Resource)
        expect(special_offer.name).to eq(attributes[:name])
      end
    end
  end

  describe ".delete_special_offer", :vcr do
    it "deletes given special_offer" do
      client.delete_special_offer(4)
      assert_requested :delete, bs_url("special_offers/4")
    end
  end
end
