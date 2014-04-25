require "spec_helper"

describe BookingSync::API::Client::Reviews do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".reviews", :vcr do
    it "returns reviews" do
      expect(client.reviews).not_to be_nil
      assert_requested :get, bs_url("reviews")
    end
  end

  describe ".create_review", :vcr do
    let(:attributes) {{
      comment: "Awesome place",
      rating: 5
    }}

    it "creates a new review" do
      client.create_review(1, attributes)
      assert_requested :post, bs_url("reviews"),
        body: { booking_id: 1, reviews: [attributes] }.to_json
    end

    it "returns newly created review" do
      VCR.use_cassette('BookingSync_API_Client_Reviews/_create_review/creates_a_new_review') do
        review = client.create_review(1, attributes)
        expect(review.comment).to eql(attributes[:comment])
        expect(review.rating).to eql(attributes[:rating])
      end
    end
  end
end
