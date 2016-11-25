require "spec_helper"

describe BookingSync::API::Client::RentalsFees do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".rentals_fees", :vcr do
    it "returns rentals fees" do
      expect(client.rentals_fees).not_to be_empty
      assert_requested :get, bs_url("rentals_fees")
    end
  end

  describe ".rentals_fee", :vcr do
    it "returns a single rentals_fee" do
      rentals_fee = client.rentals_fee(3306)
      expect(rentals_fee.id).to eq 3306
    end
  end

  describe ".create_rentals_fee", :vcr do
    let(:attributes) do
      {
        fee_id: 659,
        maximum_bookable: 10,
        always_applied: true
      }
    end
    let(:rental) { BookingSync::API::Resource.new(client, id: 5116) }

    it "creates a new rentals_fee" do
      client.create_rentals_fee(rental, attributes)
      assert_requested :post, bs_url("rentals/5116/rentals_fees"),
        body: { rentals_fees: [attributes] }.to_json
    end

    it "returns newly created rentals_fee" do
      VCR.use_cassette("BookingSync_API_Client_RentalsFees/_create_rentals_fee/creates_a_new_rentals_fee") do
        rentals_fee = client.create_rentals_fee(rental, attributes)
        expect(rentals_fee.links.fee).to eq 659
        expect(rentals_fee.maximum_bookable).to eq 10
        expect(rentals_fee.always_applied).to eq true
      end
    end
  end
end
