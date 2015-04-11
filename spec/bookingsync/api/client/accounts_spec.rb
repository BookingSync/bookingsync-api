require "spec_helper"

describe BookingSync::API::Client::Accounts do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".accounts", :vcr do
    it "returns accounts" do
      expect(client.accounts).not_to be_empty
      assert_requested :get, bs_url("accounts")
    end
  end
end
