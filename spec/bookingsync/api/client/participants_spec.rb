require "spec_helper"

describe BookingSync::API::Client::Participants do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".participants", :vcr do
    it "returns participants" do
      expect(client.participants).not_to be_empty
      assert_requested :get, bs_url("participants")
    end
  end

  describe ".participant", :vcr do
    let(:prefetched_participant_id) {
      find_resource("#{@casette_base_path}_participants/returns_participants.yml", "participants")[:id]
    }

    it "returns a single participant" do
      participant = client.participant(prefetched_participant_id)
      expect(participant.id).to eq prefetched_participant_id
    end
  end

  describe ".create_participant", :vcr do
    let(:attributes) do
      { read: false }
    end
    let(:conversation) { BookingSync::API::Resource.new(client, id: 1) }
    let(:member) { BookingSync::API::Resource.new(client, id: 1) }

    it "creates a new participant" do
      allow(member).to receive(:class).and_return(BookingSync::API::Resource.new(client, name: "Client"))

      client.create_participant(conversation, member, attributes)
      assert_requested :post, bs_url("participants"),
        body: {
          participants: [
            attributes.merge(conversation_id: conversation.id,
              member_id: member.id, member_type: member.class.name)
          ]
        }.to_json
    end

    it "returns newly created participant" do
      VCR.use_cassette("BookingSync_API_Client_Participants/_create_participant/creates_a_new_participant") do
        participant = client.create_participant(conversation, member, attributes)
        expect(participant[:links][:conversation]).to eq(1)
        expect(participant[:links][:member][:id]).to eq(1)
        expect(participant.read_at).to be_nil
      end
    end
  end

  describe ".edit_participant", :vcr do
    let(:attributes) do
      { read: true }
    end
    let(:created_participant_id) {
      find_resource("#{@casette_base_path}_create_participant/creates_a_new_participant.yml", "participants")[:id]
    }

    it "updates given participant by ID" do
      client.edit_participant(created_participant_id, attributes)
      assert_requested :put, bs_url("participants/#{created_participant_id}"),
        body: { participants: [attributes] }.to_json
    end

    it "returns updated participant" do
      VCR.use_cassette("BookingSync_API_Client_Participants/_edit_participant/updates_given_participant_by_ID") do
        participant = client.edit_participant(created_participant_id, attributes)
        expect(participant).to be_kind_of(BookingSync::API::Resource)
        expect(participant.read_at).to be_truthy
      end
    end
  end
end
