require "spec_helper"

describe BookingSync::API::Client::Reviews do

  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".reviews", :vcr do
    it "returns reviews" do
      expect(client.reviews).not_to be_nil
      assert_requested :get, bs_url("reviews")
    end

    context "with specified fields in options" do
      it "returns rentals with filtered fields" do
        reviews = client.reviews(fields: [:name, :comment])
        expect(reviews).not_to be_nil
        assert_requested :get, bs_url("reviews?fields=name,comment")
      end
    end
  end
end
