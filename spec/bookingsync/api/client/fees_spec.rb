require "spec_helper"

describe BookingSync::API::Client::Fees do
  let(:api) { BookingSync::API::Client.new(test_access_token) }

  describe ".fees", :vcr do
    it "returns fees" do
      expect(api.fees).not_to be_empty
      assert_requested :get, bs_url("fees")
    end
  end
end
