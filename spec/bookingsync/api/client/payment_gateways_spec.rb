require "spec_helper"

describe BookingSync::API::Client::PaymentGateways do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".payment_gateways", :vcr do
    it "returns payment gateways" do
      expect(client.payment_gateways).not_to be_empty
      assert_requested :get, bs_url("payment_gateways")
    end
  end

  describe ".payment_gateway", :vcr do
    let(:prefetched_payment_gateway_id) {
      find_resource("#{@casette_base_path}_payment_gateways/returns_payment_gateways.yml", "payment_gateways")[:id]
    }

    it "returns a single payment gateway" do
      payment_gateway = client.payment_gateway(prefetched_payment_gateway_id)
      expect(payment_gateway.id).to eq prefetched_payment_gateway_id
    end
  end
end
