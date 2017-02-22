require "spec_helper"

describe BookingSync::API::Client::Payments do
  let(:api) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".payments", :vcr do
    it "returns payments" do
      expect(api.payments).not_to be_empty
      assert_requested :get, bs_url("payments")
    end
  end

  describe ".payment", :vcr do
    let(:prefetched_payment_id) {
      find_resource("#{@casette_base_path}_payments/returns_payments.yml", "payments")[:id]
    }

    it "returns a single payment" do
      payment = api.payment(prefetched_payment_id)
      expect(payment.id).to eq prefetched_payment_id
    end
  end

  describe ".create_payment", :vcr do
    let(:booking_id) do
      bookings = find_resources("#{casette_dir}/BookingSync_API_Client_Bookings/_bookings/returns_bookings.yml", "bookings")
      bookings.detect { |b| b["status"] == "Booked" }["id"]
    end
    let(:attributes) { { amount_in_cents: 200, kind: "cash", paid_at: "2016-12-06T11:34:05Z" } }

    it "creates a new payment" do
      api.create_payment(booking_id, attributes)
      assert_requested :post, bs_url("bookings/#{booking_id}/payments"),
        body: { payments: [attributes] }.to_json
    end

    it "returns newly created payment" do
      VCR.use_cassette("BookingSync_API_Client_Payments/_create_payment/creates_a_new_payment") do
        payment = api.create_payment(booking_id, attributes)
        expect(payment.amount_in_cents).to eq(200)
        expect(payment.kind).to eq("cash")
      end
    end
  end

  describe ".edit_payment", :vcr do
    let(:created_payment_id) {
      find_resource("#{@casette_base_path}_create_payment/creates_a_new_payment.yml", "payments")[:id]
    }

    it "updates given payment by ID" do
      api.edit_payment(created_payment_id, kind: "cheque")
      assert_requested :put, bs_url("payments/#{created_payment_id}"),
        body: { payments: [{ kind: "cheque" }] }.to_json
    end

    it "returns updated payment" do
      VCR.use_cassette("BookingSync_API_Client_Payments/_edit_payment/updates_given_payment_by_ID") do
        payment = api.edit_payment(created_payment_id, kind: "cheque")
        expect(payment).to be_kind_of(BookingSync::API::Resource)
        expect(payment.kind).to eq("cheque")
      end
    end
  end

  describe ".cancel_payment", :vcr do
    let(:created_payment_id) {
      find_resource("#{@casette_base_path}_create_payment/creates_a_new_payment.yml", "payments")[:id]
    }

    it "cancels given payment" do
      api.cancel_payment(created_payment_id)
      assert_requested :delete, bs_url("payments/#{created_payment_id}")
    end
  end
end
