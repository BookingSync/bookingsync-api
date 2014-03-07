require "spec_helper"

describe BookingSync::API::Client::Bookings do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".bookings", :vcr do
    it "returns bookings" do
      expect(client.bookings).not_to be_nil
      assert_requested :get, bs_url("bookings")
    end
  end
end
