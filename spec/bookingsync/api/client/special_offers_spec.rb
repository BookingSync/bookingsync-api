require "spec_helper"

describe BookingSync::API::Client::SpecialOffers do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".special_offers", :vcr do
    it "returns special_offers" do
      expect(client.special_offers).not_to be_empty
      assert_requested :get, bs_url("special_offers")
    end
  end

  describe ".special_offer", :vcr do
    let(:prefetched_special_offer_id) {
      find_resource("#{@casette_base_path}_special_offers/returns_special_offers.yml", "special_offers")[:id]
    }

    it "returns a single special_offer" do
      special_offer = client.special_offer(prefetched_special_offer_id)
      expect(special_offer.id).to eq prefetched_special_offer_id
    end
  end

  describe ".create_special_offer", :vcr do
    let(:attributes) {
      {
        name_en: "New special offer",
        start_date: "2017-04-28",
        end_date: "2017-05-28",
        discount: 5
      }
    }
    let(:rental) do
      find_resource("#{casette_dir}/BookingSync_API_Client_Rentals/_rental/returns_a_single_rental.yml", "rentals")
    end

    it "creates a new special_offer" do
      client.create_special_offer(rental, attributes)
      assert_requested :post, bs_url("rentals/#{rental}/special_offers"),
        body: { special_offers: [attributes] }.to_json
    end

    it "returns newly created special_offer" do
      VCR.use_cassette("BookingSync_API_Client_SpecialOffers/_create_special_offer/creates_a_new_special_offer") do
        special_offer = client.create_special_offer(rental, attributes)
        expect(special_offer.name).to eq(en: attributes[:name_en])
      end
    end
  end

  describe ".edit_special_offer", :vcr do
    let(:attributes) {
      { name_en: "Updated special offer" }
    }
    let(:created_special_offer_id) {
      find_resource("#{@casette_base_path}_create_special_offer/creates_a_new_special_offer.yml", "special_offers")[:id]
    }

    it "updates given special_offer by ID" do
      client.edit_special_offer(created_special_offer_id, attributes)
      assert_requested :put, bs_url("special_offers/#{created_special_offer_id}"),
        body: { special_offers: [attributes] }.to_json
    end

    it "returns updated special_offer" do
      VCR.use_cassette("BookingSync_API_Client_SpecialOffers/_edit_special_offer/updates_given_special_offer_by_ID") do
        special_offer = client.edit_special_offer(created_special_offer_id, attributes)
        expect(special_offer).to be_kind_of(BookingSync::API::Resource)
        expect(special_offer.name).to eq(en: attributes[:name_en])
      end
    end
  end

  describe ".delete_special_offer", :vcr do
    let(:created_special_offer_id) {
      find_resource("#{@casette_base_path}_create_special_offer/creates_a_new_special_offer.yml", "special_offers")[:id]
    }

    it "deletes given special_offer" do
      client.delete_special_offer(created_special_offer_id)
      assert_requested :delete, bs_url("special_offers/#{created_special_offer_id}")
    end
  end
end
