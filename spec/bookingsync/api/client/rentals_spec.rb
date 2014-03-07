require "spec_helper"

describe BookingSync::API::Client::Rentals do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".rentals", :vcr do
    it "returns rentals" do
      expect(client.rentals).not_to be_nil
      assert_requested :get, bs_url("rentals")
    end

    context "with specified fields in options" do
      it "returns rentals with filtered fields" do
        rentals = client.rentals(fields: :name)
        expect(rentals).not_to be_nil
        assert_requested :get, bs_url("rentals?fields=name")
      end
    end
  end
end
