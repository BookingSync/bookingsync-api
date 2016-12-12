require "spec_helper"

describe BookingSync::API::Client::BookingsPayments do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".bookings_payments", :vcr do
    it "returns bookings_payments" do
      expect(client.bookings_payments).not_to be_empty
      assert_requested :get, bs_url("bookings_payments")
    end
  end

  describe ".bookings_payment", :vcr do
    let(:prefetched_bookings_payment_id) {
      find_resource("#{@casette_base_path}_bookings_payments/returns_bookings_payments.yml", "bookings_payments")[:id]
    }

    it "returns a single bookings_payment" do
      bookings_payment = client.bookings_payment(prefetched_bookings_payment_id)
      expect(bookings_payment.id).to eq prefetched_bookings_payment_id
    end
  end
end
