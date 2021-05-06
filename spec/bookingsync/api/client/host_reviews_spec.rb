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

  describe ".create_draft_host_review", :vcr do
    let(:attributes) { { comment: "Awesome guest", expires_at: "2045-06-07T12:00:00Z", shareable: false } }
    let(:booking) { BookingSync::API::Resource.new(client, id: 228) }

    it "creates a new draft review" do
      client.create_draft_host_review(booking, attributes)
      assert_requested :post, bs_url("bookings/#{booking}/host_reviews/draft"),
        body: { host_reviews: [attributes] }.to_json
    end

    it "returns newly created review" do
      VCR.use_cassette("BookingSync_API_Client_HostReviews/_create_draft_host_review/creates_a_new_draft_review") do
        host_review = client.create_draft_host_review(booking, attributes)
        expect(host_review.comment).to eq(attributes[:comment])
      end
    end
  end

  describe ".create_submitted_host_review", :vcr do
    let(:attributes) do
      {
        comment: "Awesome guest",
        submitted_at: "2020-06-06T12:00:00Z",
        expires_at: "2020-06-07T12:00:00Z",
        is_guest_recommended: true,
        shareable: false
      }
    end
    let(:booking) { BookingSync::API::Resource.new(client, id: 227) }

    it "creates a new submitted review" do
      client.create_submitted_host_review(booking, attributes)
      assert_requested :post, bs_url("bookings/#{booking}/host_reviews"),
        body: { host_reviews: [attributes] }.to_json
    end

    it "returns newly created review" do
      VCR.use_cassette("BookingSync_API_Client_HostReviews/_create_submitted_host_review/creates_a_new_submitted_review") do
        host_review = client.create_submitted_host_review(booking, attributes)
        expect(host_review.comment).to eq(attributes[:comment])
      end
    end
  end

  describe ".edit_draft_host_review", :vcr do
    let(:attributes) { { comment: "Woops, not great after all, he emptied the fridge" } }
    let(:created_host_review_id) do
      find_resource("#{@casette_base_path}_create_draft_host_review/creates_a_new_draft_review.yml", "host_reviews")[:id]
    end

    it "updates given host review by ID" do
      client.edit_draft_host_review(created_host_review_id, attributes)
      assert_requested :put, bs_url("host_reviews/draft/#{created_host_review_id}"),
        body: { host_reviews: [attributes] }.to_json
    end

    it "returns updated host review" do
      VCR.use_cassette("BookingSync_API_Client_HostReviews/_edit_draft_host_review/updates_given_host_review_by_ID") do
        host_review = client.edit_draft_host_review(created_host_review_id, attributes)
        expect(host_review).to be_kind_of(BookingSync::API::Resource)
        expect(host_review.comment).to eq("Woops, not great after all, he emptied the fridge")
      end
    end
  end

  describe ".submit_draft_host_review", :vcr do
    let(:attributes) do
      {
        comment: "Woops, not great after all, he emptied the fridge",
        submitted_at: "2021-06-06T12:00:00Z",
        is_guest_recommended: false
      }
    end
    let(:created_host_review_id) do
      find_resource("#{@casette_base_path}_create_draft_host_review/creates_a_new_draft_review.yml", "host_reviews")[:id]
    end

    it "submits given host review by ID" do
      client.submit_draft_host_review(created_host_review_id, attributes)
      assert_requested :put, bs_url("host_reviews/draft/#{created_host_review_id}/submit"),
        body: { host_reviews: [attributes] }.to_json
    end

    it "returns updated host review" do
      VCR.use_cassette("BookingSync_API_Client_HostReviews/_submit_draft_host_review/submits_given_host_review_by_ID") do
        host_review = client.submit_draft_host_review(created_host_review_id, attributes)
        expect(host_review).to be_kind_of(BookingSync::API::Resource)
        expect(
          host_review.slice(:comment, :submitted_at, :is_guest_recommended)
        ).to eq(
          comment: "Woops, not great after all, he emptied the fridge",
          submitted_at: Time.parse("2021-06-06T12:00:00Z"),
          is_guest_recommended: false
        )
      end
    end
  end
end
