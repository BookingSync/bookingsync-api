require "spec_helper"

describe BookingSync::API::Client::Fees do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".fees", :vcr do
    it "returns fees" do
      expect(client.fees).not_to be_empty
      assert_requested :get, bs_url("fees")
    end
  end

  describe ".fee", :vcr do
    it "returns a single fee" do
      fee = client.fee(474)
      expect(fee.id).to eq 474
    end
  end
end
