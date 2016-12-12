require "spec_helper"

describe BookingSync::API::Client::Rates do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".rates", :vcr do
    it "returns rates" do
      expect(client.rates).not_to be_empty
      assert_requested :get, bs_url("rates")
    end
  end

  describe ".rate", :vcr do
    let(:prefetched_rate_id) {
      find_resource("#{@casette_base_path}_rates/returns_rates.yml", "rates")[:id]
    }

    it "returns a single rate" do
      rate = client.rate(prefetched_rate_id)
      expect(rate.id).to eq prefetched_rate_id
    end
  end
end
