require "spec_helper"

describe BookingSync::API::Client::HostReviews do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".host_reviews", :vcr do
    it "returns host_reviews" do
      expect(client.host_reviews).not_to be_empty
      assert_requested :get, bs_url("host_reviews")
    end
  end

  describe ".host_review", :vcr do
    let(:prefetched_host_review_id) do
      find_resource("#{@casette_base_path}_host_reviews/returns_host_reviews.yml", "host_reviews")[:id]
    end

    it "returns a single host_review" do
      host_review = client.host_review(prefetched_host_review_id)
      expect(host_review.id).to eq prefetched_host_review_id
    end
  end

  describe ".create_host_review", :vcr do
    let(:attributes) { { comment: "Awesome place" } }
    let(:booking) { BookingSync::API::Resource.new(client, id: 96) }

    it "creates a new review" do
      client.create_host_review(booking, attributes)
      assert_requested :post, bs_url("bookings/#{booking}/host_reviews"),
        body: { host_reviews: [attributes] }.to_json
    end

    it "returns newly created review" do
      VCR.use_cassette("BookingSync_API_Client_HostReviews/_create_host_review/creates_a_new_review") do
        host_review = client.create_host_review(booking, attributes)
        expect(host_review.comment).to eq(attributes[:comment])
      end
    end
  end

  describe ".edit_host_review", :vcr do
    let(:attributes) do
      {
        submitted_at: "2021-03-22T12:00:00Z",
        comment: "Awesome guest, great cook!",
        is_guest_recommended: true,
        private_comment: "Thanks doing the dishes" }
    end
    let(:created_host_review_id) do
      find_resource("#{@casette_base_path}_create_host_review/creates_a_new_review.yml", "host_reviews")[:id]
    end

    it "updates given host review by ID" do
      client.edit_host_review(created_host_review_id, attributes)
      assert_requested :put, bs_url("host_reviews/#{created_host_review_id}"),
        body: { host_reviews: [attributes] }.to_json
    end

    it "returns updated host review" do
      VCR.use_cassette("BookingSync_API_Client_HostReviews/_edit_host_review/updates_given_host_review_by_ID") do
        host_review = client.edit_host_review(created_host_review_id, attributes)
        expect(host_review).to be_kind_of(BookingSync::API::Resource)
        expect(host_review.private_comment).to eq("Thanks doing the dishes")
      end
    end
  end
end
