require "spec_helper"

describe BookingSync::API::Client::Payments do
  let(:api) { BookingSync::API::Client.new(test_access_token) }

  describe ".payments", :vcr do
    it "returns payments" do
      expect(api.payments).not_to be_empty
      assert_requested :get, bs_url("payments")
    end
  end

  describe ".payment", :vcr do
    it "returns a single payment" do
      payment = api.payment(71959)
      expect(payment.id).to eq 71959
    end
  end

  describe ".create_payment", :vcr do
    let(:attributes) {{
      amount: 200,
      kind: 'cash'
    }}

    it "creates a new payment" do
      api.create_payment(1, attributes)
      assert_requested :post, bs_url("payments"),
        body: { booking_id: 1, payments: [attributes]}.to_json
    end

    it "returns newly created payment" do
      VCR.use_cassette('BookingSync_API_Client_Payments/_create_payment/creates_a_new_payment') do
        payment = api.create_payment(1, attributes)
        expect(payment.amount).to eql(200)
        expect(payment.kind).to eql("cash")
      end
    end
  end

  describe ".edit_payment", :vcr do
    it "updates given payment by ID" do
      api.edit_payment(2, kind: 'cash')
      assert_requested :put, bs_url("payments/2"),
        body: {payments: [{kind: 'cash'}]}.to_json
    end

    it "returns updated payment" do
      VCR.use_cassette('BookingSync_API_Client_Payments/_edit_payment/updates_given_payment_by_ID') do
        payment = api.edit_payment(2, kind: 'cash')
        expect(payment).to be_kind_of(BookingSync::API::Resource)
        expect(payment.kind).to eq('cash')
      end
    end
  end

  describe ".cancel_payment", :vcr do
    it "cancels given payment" do
      api.cancel_payment(10)
      assert_requested :delete, bs_url("payments/10")
    end
  end
end
