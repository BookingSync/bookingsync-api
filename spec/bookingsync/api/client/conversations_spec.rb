require "spec_helper"

describe BookingSync::API::Client::Conversations do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".conversations", :vcr do
    it "returns conversations" do
      expect(client.conversations).not_to be_empty
      assert_requested :get, bs_url("inbox/conversations")
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
    let(:assignee) { BookingSync::API::Resource.new(client, id: 1) }
    let(:source) { BookingSync::API::Resource.new(client, id: 1) }
    let(:attributes) do
      { subject: "New Question", assignee_id: assignee.id, source_id: source.id }
    end

    it "creates a new conversation" do
      client.create_conversation(attributes)
      assert_requested :post, bs_url("inbox/conversations"),
        body: { conversations: [attributes] }.to_json
    end

    it "returns newly created conversation" do
      VCR.use_cassette("BookingSync_API_Client_Conversations/_create_conversation/creates_a_new_conversation") do
        conversation = client.create_conversation(attributes)
        expect(conversation.subject).to eq("New Question")
        expect(conversation[:links][:assignee]).to eq(assignee.id)
        expect(conversation[:links][:source]).to eq(source.id)
      end
    end
  end

  describe ".edit_conversation", :vcr do
    let(:new_conversation_assignee) { BookingSync::API::Resource.new(client, id: 2) }
    let(:created_conversation_id) {
      find_resource("#{@casette_base_path}_create_conversation/creates_a_new_conversation.yml", "conversations")[:id]
    }
    let(:attributes) {
      { closed: true, assignee_id: new_conversation_assignee.id }
    }

    it "updates given conversation by ID" do
      client.edit_conversation(created_conversation_id, attributes)
      assert_requested :put, bs_url("inbox/conversations/#{created_conversation_id}"),
        body: { conversations: [attributes] }.to_json
    end

    it "returns updated conversation" do
      VCR.use_cassette("BookingSync_API_Client_Conversations/_edit_conversation/updates_given_conversation_by_ID") do
        conversation = client.edit_conversation(created_conversation_id, attributes)
        expect(conversation).to be_kind_of(BookingSync::API::Resource)
        expect(conversation[:links][:assignee]).to eq(new_conversation_assignee.id)
      end
    end
  end

  describe ".connect_booking_to_conversation", :vcr do
    let(:booking_to_be_connected) { BookingSync::API::Resource.new(client, id: 40) }
    let(:prefetched_conversation_id) {
      find_resource("#{@casette_base_path}_conversations/returns_conversations.yml", "conversations")[:id]
    }
    let(:attributes) { { id: booking_to_be_connected.id } }

    it "connects given conversation with booking" do
      client.connect_booking_to_conversation(prefetched_conversation_id, attributes)
      assert_requested :put, bs_url("inbox/conversations/#{prefetched_conversation_id}/connect_booking"),
        body: { bookings: [attributes] }.to_json
    end

    it "returns conversation with updated links" do
      casette_path = "BookingSync_API_Client_Conversations/_connect_booking_to_conversation" \
                     "/connects_given_conversation_with_booking"
      VCR.use_cassette(casette_path) do
        initial_conversation = client.conversation(prefetched_conversation_id)
        expect(initial_conversation[:links][:bookings]).to match_array []
        conversation = client.connect_booking_to_conversation(prefetched_conversation_id, attributes)
        expect(conversation).to be_kind_of(BookingSync::API::Resource)
        expect(conversation[:links][:bookings]).to match_array [booking_to_be_connected.id]
      end
    end
  end

  describe ".disconnect_booking_from_conversation", :vcr do
    let(:booking_to_be_disconnected) { BookingSync::API::Resource.new(client, id: 40) }
    let(:prefetched_conversation_id) {
      find_resource("#{@casette_base_path}_conversations/returns_conversations.yml", "conversations")[:id]
    }
    let(:attributes) { { id: booking_to_be_disconnected.id } }

    it "disconnects given conversation from booking" do
      client.disconnect_booking_from_conversation(prefetched_conversation_id, attributes)
      assert_requested :put, bs_url("inbox/conversations/#{prefetched_conversation_id}/disconnect_booking"),
        body: { bookings: [attributes] }.to_json
    end

    it "returns conversation with updated links" do
      casette_path = "BookingSync_API_Client_Conversations/_disconnect_booking_from_conversation" \
                     "/disconnects_given_conversation_from_booking"
      VCR.use_cassette(casette_path) do
        initial_conversation = client.conversation(prefetched_conversation_id)
        expect(initial_conversation[:links][:bookings]).to match_array [booking_to_be_disconnected.id]
        conversation = client.disconnect_booking_from_conversation(prefetched_conversation_id, attributes)
        expect(conversation).to be_kind_of(BookingSync::API::Resource)
        expect(conversation[:links][:bookings]).to match_array []
      end
    end
  end
end
