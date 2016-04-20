require "spec_helper"

describe BookingSync::API::Client::BookingComments do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".booking_comments", :vcr do
    it "returns booking_comments" do
      expect(client.booking_comments).not_to be_empty
      assert_requested :get, bs_url("booking_comments")
    end
  end

  describe ".booking_comment", :vcr do
    it "returns single booking_comment" do
      booking_comment = client.booking_comment(4)
      expect(booking_comment.id).to eq(4)
    end
  end

  describe ".create_booking_comment", :vcr do
    let(:attributes) { { content: "Example conent" } }
    let(:booking) { BookingSync::API::Resource.new(client, id: 1) }

    it "creates booking_comment" do
      client.create_booking_comment(booking.id, attributes)
      assert_requested :post, bs_url("booking_comments"),
        body: { booking_id: 1, booking_comments: [attributes] }.to_json
    end

    it "returns newly created booking_comment" do
      booking_comment = client.create_booking_comment(booking.id, attributes)
      expect(booking_comment.content).to eq(attributes[:content])
    end
  end

  describe ".edit_booking_comment", :vcr do
    let(:attributes) { { content: "Updated content" } }

    it "updates booking_comment" do
      client.edit_booking_comment(9, attributes)
      assert_requested :put, bs_url("booking_comments/9"),
        body: { booking_comments: [attributes] }.to_json
    end

    it "returns updated booking_comment" do
      booking_comment = client.edit_booking_comment(9, attributes)
      expect(booking_comment.content).to eq(attributes[:content])
    end
  end

  describe ".delete_booking_comment", :vcr do
    it "deletes given booking_comment" do
      client.delete_booking_comment(10)
      assert_requested :delete, bs_url("booking_comments/10")
    end
  end
end
