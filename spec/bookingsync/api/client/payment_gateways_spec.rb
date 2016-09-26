require "spec_helper"

describe BookingSync::API::Client::PaymentGateways do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".payment_gateways", :vcr do
    it "returns payment gateways" do
      expect(client.payment_gateways).not_to be_empty
      assert_requested :get, bs_url("payment_gateways")
    end
  end

  describe ".payment_gateway", :vcr do
    it "returns a single payment gateway" do
      payment_gateway = client.payment_gateway(1)
      expect(payment_gateway.id).to eq 1
    end
  end
end
