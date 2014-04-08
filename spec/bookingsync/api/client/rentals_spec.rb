require "spec_helper"

describe BookingSync::API::Client::Rentals do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".rentals", :vcr do
    it "returns rentals" do
      expect(client.rentals).not_to be_nil
      assert_requested :get, bs_url("rentals")
    end
  end
end
