require "spec_helper"

describe BookingSync::API::Client::SpecialOffers do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".special_offers", :vcr do
    it "returns special_offers" do
      expect(client.special_offers).not_to be_nil
      assert_requested :get, bs_url("special_offers")
    end

    context "with specified fields in options" do
      it "returns rentals with filtered fields" do
        special_offers = client.special_offers(fields: [:name, :rental_id])
        expect(special_offers).not_to be_nil
        assert_requested :get, bs_url("special_offers?fields=name,rental_id")
      end
    end
  end
end
