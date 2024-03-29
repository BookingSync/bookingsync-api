require "spec_helper"

describe BookingSync::API::Client::Reviews do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".reviews", :vcr do
    it "returns reviews" do
      expect(client.reviews).not_to be_empty
      assert_requested :get, bs_url("reviews")
    end
  end

  describe ".review", :vcr do
    let(:prefetched_review_id) {
      find_resource("#{@casette_base_path}_reviews/returns_reviews.yml", "reviews")[:id]
    }

    it "returns a single review" do
      review = client.review(prefetched_review_id)
      expect(review.id).to eq prefetched_review_id
    end
  end

  describe ".create_review", :vcr do
    let(:attributes) { { comment: "Awesome place", rating: 5 } }
    let(:booking) { BookingSync::API::Resource.new(client, id: 3) }

    it "creates a new review" do
      client.create_review(booking, attributes)
      assert_requested :post, bs_url("bookings/#{booking}/reviews"),
        body: { reviews: [attributes] }.to_json
    end

    it "returns newly created review" do
      VCR.use_cassette("BookingSync_API_Client_Reviews/_create_review/creates_a_new_review") do
        review = client.create_review(booking, attributes)
        expect(review.comment).to eq(attributes[:comment])
        expect(review.rating).to eq(attributes[:rating])
      end
    end
  end

  describe ".dismiss_review", :vcr do
    let(:attributes) { { dismissed_at: "2021-12-01T16:00:00Z" } }
    let(:created_review_id) do
      find_resource("#{@casette_base_path}_create_review/creates_a_new_review.yml", "reviews")[:id]
    end

    it "dismisses review" do
      client.dismiss_review(created_review_id, attributes)
      assert_requested :put, bs_url("reviews/#{created_review_id}/dismiss"),
        body: { reviews: [attributes] }.to_json
    end

    it "returns dismissed review" do
      VCR.use_cassette("BookingSync_API_Client_Reviews/_dismiss_review/dismisses_review") do
        review = client.dismiss_review(created_review_id, attributes)
        expect(review.dismissed_at).to eq(Time.parse(attributes[:dismissed_at]))
      end
    end
  end
end
