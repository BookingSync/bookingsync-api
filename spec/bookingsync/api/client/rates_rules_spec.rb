require "spec_helper"

describe BookingSync::API::Client::RatesRules do

  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".rates_rules", :vcr do
    it "returns rates rules" do
      expect(client.rates_rules).not_to be_nil
      assert_requested :get, bs_url("rates_rules")
    end
  end
end
