require "spec_helper"

describe BookingSync::API::Client::Accounts do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".accounts", :vcr do
    it "returns accounts" do
      expect(client.accounts).not_to be_empty
      assert_requested :get, bs_url("accounts")
    end
  end

  describe ".account", :vcr do
    it "returns a single account" do
      account = client.account(3837)
      expect(account.id).to eq 3837
    end
  end
end
