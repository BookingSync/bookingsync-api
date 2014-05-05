require "spec_helper"

describe BookingSync::API::Client::Destinations do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".destinations", :vcr do
    it "returns destinations" do
      expect(client.destinations).not_to be_empty
      assert_requested :get, bs_url("destinations")
    end
  end
end
