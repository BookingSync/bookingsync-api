require "spec_helper"

describe BookingSync::API::Client::RentalsFees do
  let(:api) { BookingSync::API::Client.new(test_access_token) }

  describe ".rentals_fees", :vcr do
    it "returns rentals fees" do
      expect(api.rentals_fees).not_to be_empty
      assert_requested :get, bs_url("rentals_fees")
    end
  end
end
