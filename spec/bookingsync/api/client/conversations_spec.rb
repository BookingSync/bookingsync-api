require "spec_helper"

describe BookingSync::API::Client::Conversations do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".conversations", :vcr do
    it "returns conversations" do
      expect(client.conversations).not_to be_empty
      assert_requested :get, bs_url("conversations")
    end
  end

  describe ".conversation", :vcr do
    let(:prefetched_conversation_id) {
      find_resource("#{@casette_base_path}_conversations/returns_conversations.yml", "conversations")[:id]
    }

    it "returns a single conversation" do
      conversation = client.conversation(prefetched_conversation_id)
      expect(conversation.id).to eq prefetched_conversation_id
    end
  end

  describe ".create_conversation", :vcr do
    let(:attributes) do
      { subject: "New Question" }
    end

    it "creates a new conversation" do
      client.create_conversation(attributes)
      assert_requested :post, bs_url("conversations"),
        body: { conversations: [attributes] }.to_json
    end

    it "returns newly created conversation" do
      VCR.use_cassette("BookingSync_API_Client_Conversations/_create_conversation/creates_a_new_conversation") do
        conversation = client.create_conversation(attributes)
        expect(conversation.subject).to eq("New Question")
      end
    end
  end

  describe ".edit_conversation", :vcr do
    let(:attributes) {
      { closed: true }
    }
    let(:created_conversation_id) {
      find_resource("#{@casette_base_path}_create_conversation/creates_a_new_conversation.yml", "conversations")[:id]
    }

    it "updates given conversation by ID" do
      client.edit_conversation(created_conversation_id, attributes)
      assert_requested :put, bs_url("conversations/#{created_conversation_id}"),
        body: { conversations: [attributes] }.to_json
    end

    it "returns updated conversation" do
      VCR.use_cassette("BookingSync_API_Client_Conversations/_edit_conversation/updates_given_conversation_by_ID") do
        conversation = client.edit_conversation(created_conversation_id, attributes)
        expect(conversation).to be_kind_of(BookingSync::API::Resource)
        expect(conversation.closed_at).to be_truthy
      end
    end
  end
end
