require "spec_helper"

describe BookingSync::API::Client::Taxes do
  let(:api) { BookingSync::API::Client.new(test_access_token) }

  describe ".taxes", :vcr do
    it "returns taxes" do
      expect(api.taxes).not_to be_empty
      assert_requested :get, bs_url("taxes")
    end
  end
end
