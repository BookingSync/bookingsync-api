require "spec_helper"

describe BookingSync::API::Client::BookingsTaxes do
  let(:api) { BookingSync::API::Client.new(test_access_token) }

  describe ".bookings_taxes", :vcr do
    it "returns bookings taxes" do
      expect(api.bookings_taxes).not_to be_empty
      assert_requested :get, bs_url("bookings_taxes")
    end
  end
end
