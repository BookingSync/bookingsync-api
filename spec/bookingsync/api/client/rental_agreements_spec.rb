require "spec_helper"

describe BookingSync::API::Client::RentalAgreements do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".rental_agreements", :vcr do
    it "returns rental agreements" do
      expect(client.rental_agreements).not_to be_nil
      assert_requested :get, bs_url("rental_agreements")
    end
  end
end
