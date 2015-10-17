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
end
