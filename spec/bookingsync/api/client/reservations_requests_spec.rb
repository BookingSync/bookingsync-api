require "spec_helper"

describe BookingSync::API::Client::ReservationsRequests do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".reservations_requests", :vcr do
    it "returns reservations requests" do
      expect(client.reservations_requests).not_to be_empty
      assert_requested :get, bs_url("reservations/requests")
    end

    describe "pagination" do
      context "with auto_paginate: true" do
        it "returns all reservations requests joined from many requests" do
          requests = client.reservations_requests(per_page: 2, auto_paginate: true)
          expect(requests.size).to eq(4)
        end
      end
    end
  end

  describe ".reservations_request", :vcr do
    let(:prefetched_reservations_request_id) {
      find_resource("#{@casette_base_path}_reservations_requests/returns_reservations_requests.yml", "requests")[:id]
    }

    it "returns a single reservations request" do
      reservations_request = client.reservations_request(prefetched_reservations_request_id)
      expect(reservations_request.id).to eq prefetched_reservations_request_id
    end
  end

  describe ".create_reservation_request", :vcr do
    let(:attributes) do
      {
        conversation_id: 123,
        rental_id:       456,
        client_id:       789,
        booking_id:      101,
        expires_at:      "2026-06-25T12:00:00Z",
        booking_payload: {
          start_date:  "2026-07-01",
          end_date:    "2026-07-08",
          adults:      2,
          children:    0,
          final_price: "950.00",
          currency:    "EUR"
        }
      }
    end

    it "creates a new reservations request" do
      client.create_reservation_request(attributes)
      assert_requested :post, bs_url("reservations/requests"),
        body: { reservations_requests: [attributes] }.to_json
    end

    it "returns newly created reservations request" do
      VCR.use_cassette("BookingSync_API_Client_ReservationsRequests/_create_reservation_request/creates_a_new_reservations_request") do
        reservations_request = client.create_reservation_request(attributes)
        expect(reservations_request.links.rental).to eq(456)
        expect(reservations_request.expires_at).to eq(Time.parse("2026-06-25T12:00:00Z"))
      end
    end
  end

  describe ".patch_reservation_request", :vcr do
    let(:created_reservations_request_id) {
      find_resource("#{@casette_base_path}_create_reservation_request/creates_a_new_reservations_request.yml", "requests")[:id]
    }

    it "updates given reservations request by ID" do
      client.patch_reservation_request(created_reservations_request_id, expires_at: "2026-07-01T12:00:00Z")
      assert_requested :patch, bs_url("reservations/requests/#{created_reservations_request_id}"),
        body: { reservations_requests: [{ expires_at: "2026-07-01T12:00:00Z" }] }.to_json
    end

    it "returns updated reservations request" do
      VCR.use_cassette("BookingSync_API_Client_ReservationsRequests/_patch_reservation_request/updates_given_reservations_request_by_ID") do
        reservations_request = client.patch_reservation_request(created_reservations_request_id, expires_at: "2026-07-01T12:00:00Z")
        expect(reservations_request).to be_kind_of(BookingSync::API::Resource)
        expect(reservations_request.expires_at).to eq(Time.parse("2026-07-01T12:00:00Z"))
      end
    end
  end

  describe ".delete_reservation_request", :vcr do
    let(:reservations_request_id_to_be_deleted) { 60 }

    it "deletes given reservations request" do
      expect(client.delete_reservation_request(reservations_request_id_to_be_deleted)).to be_nil
      assert_requested :delete, bs_url("reservations/requests/#{reservations_request_id_to_be_deleted}")
    end
  end
end
