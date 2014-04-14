require "spec_helper"

describe BookingSync::API::Client::RatesTables do

  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".rates_tables", :vcr do
    it "returns rates tables" do
      expect(client.rates_tables).not_to be_nil
      assert_requested :get, bs_url("rates_tables")
    end
  end
end
