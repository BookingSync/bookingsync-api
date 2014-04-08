require "spec_helper"

describe BookingSync::API::Client::SpecialOffers do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".special_offers", :vcr do
    it "returns special_offers" do
      expect(client.special_offers).not_to be_nil
      assert_requested :get, bs_url("special_offers")
    end
  end
end
