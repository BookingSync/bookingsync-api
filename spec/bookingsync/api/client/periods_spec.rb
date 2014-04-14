require "spec_helper"

describe BookingSync::API::Client::Periods do

  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".periods", :vcr do
    it "returns periods" do
      expect(client.periods).not_to be_nil
      assert_requested :get, bs_url("periods")
    end
  end
end
