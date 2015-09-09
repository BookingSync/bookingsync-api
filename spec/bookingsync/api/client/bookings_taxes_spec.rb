require "spec_helper"

describe BookingSync::API::Client::BookingsTaxes do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".bookings_taxes", :vcr do
    it "returns bookings taxes" do
      expect(client.bookings_taxes).not_to be_empty
      assert_requested :get, bs_url("bookings_taxes")
    end
  end

  describe ".bookings_tax", :vcr do
    it "returns a single bookings_tax" do
      bookings_tax = client.bookings_tax(8157)
      expect(bookings_tax.id).to eq 8157
    end
  end
end
