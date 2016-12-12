require "spec_helper"

describe BookingSync::API::Client::BookingsTaxes do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".bookings_taxes", :vcr do
    it "returns bookings taxes" do
      expect(client.bookings_taxes).not_to be_empty
      assert_requested :get, bs_url("bookings_taxes")
    end
  end

  describe ".bookings_tax", :vcr do
    let(:prefetched_bookings_tax_id) {
      find_resource("#{@casette_base_path}_bookings_taxes/returns_bookings_taxes.yml", "bookings_taxes")[:id]
    }

    it "returns a single bookings_tax" do
      bookings_tax = client.bookings_tax(prefetched_bookings_tax_id)
      expect(bookings_tax.id).to eq prefetched_bookings_tax_id
    end
  end
end
