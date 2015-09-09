require "spec_helper"

describe BookingSync::API::Client::Rates do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".rates", :vcr do
    it "returns rates" do
      expect(client.rates).not_to be_empty
      assert_requested :get, bs_url("rates")
    end
  end

  describe ".rate", :vcr do
    it "returns a single rate" do
      rate = client.rate(18577)
      expect(rate.id).to eq 18577
    end
  end
end
