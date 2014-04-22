require "spec_helper"

describe BookingSync::API::Client::BookingsPayments do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".bookings_payments", :vcr do
    it "returns bookings_payments" do
      expect(client.bookings_payments).not_to be_nil
      assert_requested :get, bs_url("bookings_payments")
    end
  end
end
