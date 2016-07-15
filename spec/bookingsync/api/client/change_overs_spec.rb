require "spec_helper"

describe BookingSync::API::Client::ChangeOvers do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".change_overs", :vcr do
    it "returns change_overs" do
      expect(client.change_overs).not_to be_empty
      assert_requested :get, bs_url("change_overs")
    end
  end

  describe ".change_over", :vcr do
    it "returns a single change_over" do
      change_over = client.change_over(2)
      expect(change_over.id).to eq 2
    end
  end
end
