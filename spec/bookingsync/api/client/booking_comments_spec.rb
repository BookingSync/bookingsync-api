require "spec_helper"

describe BookingSync::API::Client::BookingComments do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".booking_comments", :vcr do
    it "returns booking_comments" do
      expect(client.booking_comments).not_to be_empty
      assert_requested :get, bs_url("booking_comments")
    end
  end

  describe ".booking_comment", :vcr do
    let(:prefetched_booking_comment_id) {
      find_resource("#{@casette_base_path}_booking_comments/returns_booking_comments.yml", "booking_comments")[:id]
    }

    it "returns single booking_comment" do
      booking_comment = client.booking_comment(prefetched_booking_comment_id)
      expect(booking_comment.id).to eq(prefetched_booking_comment_id)
    end
  end

  describe ".create_booking_comment", :vcr do
    let(:attributes) { { content: "Example content" } }
    let(:booking) { BookingSync::API::Resource.new(client, id: 817604) }

    it "creates booking_comment" do
      client.create_booking_comment(booking.id, attributes)
      assert_requested :post, bs_url("booking_comments"),
        body: { booking_id: booking.id, booking_comments: [attributes] }.to_json
    end

    it "returns newly created booking_comment" do
      booking_comment = client.create_booking_comment(booking.id, attributes)
      expect(booking_comment.content).to eq(attributes[:content])
    end
  end

  describe ".edit_booking_comment", :vcr do
    let(:attributes) { { content: "Updated content" } }
    let(:created_booking_comment_id) {
      find_resource("#{@casette_base_path}_create_booking_comment/creates_booking_comment.yml", "booking_comments")[:id]
    }

    it "updates booking_comment" do
      client.edit_booking_comment(created_booking_comment_id, attributes)
      assert_requested :put, bs_url("booking_comments/#{created_booking_comment_id}"),
        body: { booking_comments: [attributes] }.to_json
    end

    it "returns updated booking_comment" do
      booking_comment = client.edit_booking_comment(created_booking_comment_id, attributes)
      expect(booking_comment.content).to eq(attributes[:content])
    end
  end

  describe ".delete_booking_comment", :vcr do
    let(:created_booking_comment_id) {
      find_resource("#{@casette_base_path}_create_booking_comment/creates_booking_comment.yml", "booking_comments")[:id]
    }

    it "deletes given booking_comment" do
      client.delete_booking_comment(created_booking_comment_id)
      assert_requested :delete, bs_url("booking_comments/#{created_booking_comment_id}")
    end
  end
end
