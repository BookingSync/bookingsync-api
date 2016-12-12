require "spec_helper"

describe BookingSync::API::Client::BookingsFees do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".bookings_fees", :vcr do
    it "returns bookings fees" do
      expect(client.bookings_fees).not_to be_empty
      assert_requested :get, bs_url("bookings_fees")
    end
  end

  describe ".bookings_fee", :vcr do
    let(:prefetched_bookings_fee_id) {
      find_resource("#{@casette_base_path}_bookings_fees/returns_bookings_fees.yml", "bookings_fees")[:id]
    }

    it "returns a single bookings_fee" do
      bookings_fee = client.bookings_fee(prefetched_bookings_fee_id)
      expect(bookings_fee.id).to eq prefetched_bookings_fee_id
    end
  end
end
