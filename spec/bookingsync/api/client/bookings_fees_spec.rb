require "spec_helper"

describe BookingSync::API::Client::BookingsFees do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".bookings_fees", :vcr do
    it "returns bookings fees" do
      expect(client.bookings_fees).not_to be_empty
      assert_requested :get, bs_url("bookings_fees")
    end
  end

  describe ".bookings_fee", :vcr do
    it "returns a single bookings_fee" do
      bookings_fee = client.bookings_fee(8112)
      expect(bookings_fee.id).to eq 8112
    end
  end
end
