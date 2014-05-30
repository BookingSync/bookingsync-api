require "spec_helper"

describe BookingSync::API::Client::Availabilities do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".availabilities", :vcr do
    it "returns availabilities" do
      expect(client.availabilities).not_to be_empty
      assert_requested :get, bs_url("availabilities")
    end
  end
end
