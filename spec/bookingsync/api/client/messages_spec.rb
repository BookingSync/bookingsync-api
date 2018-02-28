require "spec_helper"

describe BookingSync::API::Client::Messages do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".messages", :vcr do
    it "returns messages" do
      expect(client.messages).not_to be_empty
      assert_requested :get, bs_url("messages")
    end
  end

  describe ".message", :vcr do
    let(:prefetched_message_id) {
      find_resource("#{@casette_base_path}_messages/returns_messages.yml", "messages")[:id]
    }

    it "returns a single message" do
      message = client.message(prefetched_message_id)
      expect(message.id).to eq prefetched_message_id
    end
  end

  describe ".create_message", :vcr do
    let(:attributes) do
      {
        content: "Message content",
        origin: "homeaway",
        visibility: "all"
      }
    end
    let(:conversation) { BookingSync::API::Resource.new(client, id: 1) }
    let(:participant) { BookingSync::API::Resource.new(client, id: 1) }

    it "creates a new message" do
      client.create_message(conversation, participant, attributes)
      assert_requested :post, bs_url("messages"),
        body: {
          messages: [
            attributes.merge(conversation_id: conversation.id, participant_id: participant.id)
          ]
        }.to_json
    end

    it "returns newly created message" do
      VCR.use_cassette("BookingSync_API_Client_Messages/_create_message/creates_a_new_message") do
        message = client.create_message(conversation, participant, attributes)
        expect(message.content).to eq("Message content")
        expect(message.origin).to eq("homeaway")
        expect(message.visibility).to eq("all")
      end
    end
  end

  describe ".edit_message", :vcr do
    let(:attributes) {
      { content: "Updated message content" }
    }
    let(:created_message_id) {
      find_resource("#{@casette_base_path}_create_message/creates_a_new_message.yml", "messages")[:id]
    }

    it "updates given message by ID" do
      client.edit_message(created_message_id, attributes)
      assert_requested :put, bs_url("messages/#{created_message_id}"),
        body: { messages: [attributes] }.to_json
    end

    it "returns updated message" do
      VCR.use_cassette("BookingSync_API_Client_Messages/_edit_message/updates_given_message_by_ID") do
        message = client.edit_message(created_message_id, attributes)
        expect(message).to be_kind_of(BookingSync::API::Resource)
        expect(message.content).to eq("Updated message content")
      end
    end
  end
end
