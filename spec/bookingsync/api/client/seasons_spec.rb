require "spec_helper"

describe BookingSync::API::Client::Seasons do

  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".seasons", :vcr do
    it "returns seasons" do
      expect(client.seasons).not_to be_nil
      assert_requested :get, bs_url("seasons")
    end
  end
end
