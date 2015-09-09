require "spec_helper"

describe BookingSync::API::Client::Reviews do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".reviews", :vcr do
    it "returns reviews" do
      expect(client.reviews).not_to be_empty
      assert_requested :get, bs_url("reviews")
    end
  end

  describe ".review", :vcr do
    it "returns a single review" do
      review = client.review(34562)
      expect(review.id).to eq 34562
    end
  end

  describe ".create_review", :vcr do
    let(:attributes) {{
      comment: "Awesome place",
      rating: 5
    }}
    let(:booking) { BookingSync::API::Resource.new(client, id: 1) }

    it "creates a new review" do
      client.create_review(booking, attributes)
      assert_requested :post, bs_url("bookings/1/reviews"),
        body: {reviews: [attributes]}.to_json
    end

    it "returns newly created review" do
      VCR.use_cassette('BookingSync_API_Client_Reviews/_create_review/creates_a_new_review') do
        review = client.create_review(booking, attributes)
        expect(review.comment).to eql(attributes[:comment])
        expect(review.rating).to eql(attributes[:rating])
      end
    end
  end
end
