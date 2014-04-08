require "spec_helper"

describe BookingSync::API::Client::Reviews do

  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".reviews", :vcr do
    it "returns reviews" do
      expect(client.reviews).not_to be_nil
      assert_requested :get, bs_url("reviews")
    end
  end
end
