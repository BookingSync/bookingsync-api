require "spec_helper"

describe BookingSync::API::Client::Accounts do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".accounts", :vcr do
    it "returns accounts" do
      expect(client.accounts).not_to be_empty
      assert_requested :get, bs_url("accounts")
    end
  end

  describe ".account", :vcr do
    let(:prefetched_account_id) {
      find_resource("#{@casette_base_path}_accounts/returns_accounts.yml", "accounts")[:id]
    }

    it "returns a single account" do
      account = client.account(prefetched_account_id)
      expect(account.id).to eq prefetched_account_id
    end
  end
end
