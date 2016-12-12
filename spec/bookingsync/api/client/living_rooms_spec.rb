require "spec_helper"

describe BookingSync::API::Client::LivingRooms do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".living_rooms", :vcr do
    it "returns living_rooms" do
      expect(client.living_rooms).not_to be_empty
      assert_requested :get, bs_url("living_rooms")
    end
  end

  describe ".living_room", :vcr do
    let(:prefetched_living_room_id) {
      find_resource("#{@casette_base_path}_living_rooms/returns_living_rooms.yml", "living_rooms")[:id]
    }

    it "returns a single living_room" do
      living_room = client.living_room(prefetched_living_room_id)
      expect(living_room.id).to eq prefetched_living_room_id
    end
  end

  describe ".create_living_room", :vcr do
    let(:attributes) { { sofa_beds_count: 2 } }
    let(:rental) { BookingSync::API::Resource.new(client, id: 5116) }

    it "creates a new living_room" do
      client.create_living_room(rental, attributes)
      assert_requested :post, bs_url("rentals/#{rental}/living_rooms"),
        body: { living_rooms: [attributes] }.to_json
    end

    it "returns newly created living_room" do
      VCR.use_cassette("BookingSync_API_Client_LivingRooms/_create_living_room/creates_a_new_living_room") do
        living_room = client.create_living_room(rental, attributes)
        expect(living_room.sofa_beds_count).to eq(attributes[:sofa_beds_count])
      end
    end
  end

  describe ".edit_living_room", :vcr do
    let(:attributes) { { sofa_beds_count: 3 } }
    let(:created_living_room_id) {
      find_resource("#{@casette_base_path}_create_living_room/creates_a_new_living_room.yml", "living_rooms")[:id]
    }

    it "updates given living_room by ID" do
      client.edit_living_room(created_living_room_id, attributes)
      assert_requested :put, bs_url("living_rooms/#{created_living_room_id}"),
        body: { living_rooms: [attributes] }.to_json
    end

    it "returns updated living_room" do
      VCR.use_cassette("BookingSync_API_Client_LivingRooms/_edit_living_room/updates_given_living_room_by_ID") do
        living_room = client.edit_living_room(created_living_room_id, attributes)
        expect(living_room).to be_kind_of(BookingSync::API::Resource)
        expect(living_room.sofa_beds_count).to eq(attributes[:sofa_beds_count])
      end
    end
  end

  describe ".cancel_living_room", :vcr do
    let(:created_living_room_id) {
      find_resource("#{@casette_base_path}_create_living_room/creates_a_new_living_room.yml", "living_rooms")[:id]
    }

    it "cancels given living_room" do
      client.cancel_living_room(created_living_room_id)
      assert_requested :delete, bs_url("living_rooms/#{created_living_room_id}")
    end
  end
end
