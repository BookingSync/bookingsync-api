require "spec_helper"

describe BookingSync::API::Client::Photos do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".photos", :vcr do
    it "returns photos" do
      expect(client.photos).not_to be_empty
      assert_requested :get, bs_url("photos")
    end
  end
end
