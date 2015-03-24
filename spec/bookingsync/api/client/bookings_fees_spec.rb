require "spec_helper"

describe BookingSync::API::Client::BookingsFees do
  let(:api) { BookingSync::API::Client.new(test_access_token) }

  describe ".bookings_fees", :vcr do
    it "returns bookings fees" do
      expect(api.bookings_fees).not_to be_empty
      assert_requested :get, bs_url("bookings_fees")
    end
  end
end
