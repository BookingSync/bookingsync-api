require "spec_helper"

describe BookingSync::API::Client::ReviewReplies do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".review_replies", :vcr do
    it "returns review_replies" do
      expect(client.review_replies).not_to be_empty
      assert_requested :get, bs_url("review_replies")
    end
  end

  describe ".review_reply", :vcr do
    let(:prefetched_review_reply_id) do
      find_resource("#{@casette_base_path}_review_replies/returns_review_replies.yml", "review_replies")[:id]
    end

    it "returns a single review_reply" do
      review_reply = client.review_reply(prefetched_review_reply_id)
      expect(review_reply.id).to eq prefetched_review_reply_id
    end
  end

  describe ".create_host_review_reply", :vcr do
    let(:attributes) { { message: "Thanks!" } }
    let(:host_review) { BookingSync::API::Resource.new(client, id: "04356dc9-1349-4e05-b818-09ccdac8d5dd") }

    it "creates a new reply to host review" do
      client.create_host_review_reply(host_review, attributes)
      assert_requested :post, bs_url("host_reviews/#{host_review}/reply"),
        body: { review_replies: [attributes] }.to_json
    end

    it "returns newly created review" do
      VCR.use_cassette("BookingSync_API_Client_ReviewReplies/_create_host_review_reply/creates_a_new_reply_to_host_review") do
        host_review_reply = client.create_host_review_reply(host_review, attributes)
        expect(host_review_reply.message).to eq(attributes[:message])
      end
    end
  end

  describe ".create_guest_review_reply", :vcr do
    let(:attributes) { { message: "Merci!" } }
    let(:guest_review) { BookingSync::API::Resource.new(client, id: 34) }

    it "creates new reply to a guest review" do
      client.create_guest_review_reply(guest_review, attributes)
      assert_requested :post, bs_url("reviews/#{guest_review}/reply"),
        body: { review_replies: [attributes] }.to_json
    end

    it "returns newly created review" do
      VCR.use_cassette("BookingSync_API_Client_ReviewReplies/_create_guest_review_reply/creates_new_reply_to_a_guest_review") do
        guest_review_reply = client.create_guest_review_reply(guest_review, attributes)
        expect(guest_review_reply.message).to eq(attributes[:message])
      end
    end
  end
end
