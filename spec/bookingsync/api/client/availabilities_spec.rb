require "spec_helper"

describe BookingSync::API::Client::Availabilities do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".availabilities", :vcr do
    it "returns availabilities" do
      expect(client.availabilities).not_to be_empty
      assert_requested :get, bs_url("availabilities")
    end
  end

  describe ".availability", :vcr do
    it "returns a single availability" do
      availability = client.availability(2)
      expect(availability.id).to eq 2
    end
  end
end
