require "spec_helper"

describe BookingSync::API::Client::Bookings do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".clients", :vcr do
    it "returns clients" do
      expect(client.clients).not_to be_nil
      assert_requested :get, bs_url("clients")
    end
  end
end