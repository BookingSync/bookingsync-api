require "spec_helper"

describe BookingSync::API::Client::BookingsPayments do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".bookings_payments", :vcr do
    it "returns bookings_payments" do
      expect(client.bookings_payments).not_to be_empty
      assert_requested :get, bs_url("bookings_payments")
    end
  end

  describe ".bookings_payment", :vcr do
    it "returns a single bookings_payment" do
      bookings_payment = client.bookings_payment(71982)
      expect(bookings_payment.id).to eq 71982
    end
  end
end
