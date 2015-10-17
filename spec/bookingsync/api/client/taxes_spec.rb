require "spec_helper"

describe BookingSync::API::Client::Taxes do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".taxes", :vcr do
    it "returns taxes" do
      expect(client.taxes).not_to be_empty
      assert_requested :get, bs_url("taxes")
    end
  end

  describe ".tax", :vcr do
    it "returns a single tax" do
      tax = client.tax(168)
      expect(tax.id).to eq 168
    end
  end
end
