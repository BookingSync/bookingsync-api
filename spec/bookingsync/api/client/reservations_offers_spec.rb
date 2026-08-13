require "spec_helper"

describe BookingSync::API::Client::ReservationsOffers do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  # Contract differs from reservations_requests (verified against live Core):
  #  - fields are flat, there is no `booking_payload` wrapper
  #  - there is no `booking_id` on create (attached later, Core-side)
  #  - money is `total_amount_cents` (integer), not a `final_price` string
  let(:attributes) do
    {
      conversation_id:    1,
      rental_id:          1,
      client_id:          1,
      start_date:         "2026-10-01",
      end_date:           "2026-10-08",
      adults:             2,
      children:           1,
      total_amount_cents: 55000,
      currency:           "EUR",
      expires_at:         "2026-09-01T12:00:00Z"
    }
  end

  describe ".reservations_offers", :vcr do
    it "returns reservations offers" do
      expect(client.reservations_offers).not_to be_empty
      assert_requested :get, bs_url("reservations/offers")
    end

    describe "pagination" do
      context "with auto_paginate: true" do
        it "returns all reservations offers joined from many requests" do
          paginated = client.reservations_offers(per_page: 2, auto_paginate: true)
          all_in_one_page = client.reservations_offers(per_page: 100)
          expect(paginated.map(&:id)).to match_array(all_in_one_page.map(&:id))
          expect(paginated.size).to be >= 3
        end
      end
    end
  end

  describe ".reservations_offer", :vcr do
    let(:prefetched_reservations_offer_id) {
      find_resource("#{@casette_base_path}_reservations_offers/returns_reservations_offers.yml", "offers")[:id]
    }

    it "returns a single reservations offer" do
      reservations_offer = client.reservations_offer(prefetched_reservations_offer_id)
      expect(reservations_offer.id).to eq prefetched_reservations_offer_id
    end
  end

  describe ".create_reservation_offer", :vcr do
    it "creates a new reservations offer" do
      client.create_reservation_offer(attributes)
      assert_requested :post, bs_url("reservations/offers"),
        body: { reservations_offers: [attributes] }.to_json
    end

    it "returns newly created reservations offer" do
      VCR.use_cassette("BookingSync_API_Client_ReservationsOffers/_create_reservation_offer/creates_a_new_reservations_offer") do
        reservations_offer = client.create_reservation_offer(attributes)
        expect(reservations_offer.links.rental).to eq(1)
        expect(reservations_offer.currency).to eq("EUR")
        expect(reservations_offer.total_amount_cents).to eq(55000)
        expect(reservations_offer.status).to eq("pending")
      end
    end
  end

  describe ".patch_reservation_offer", :vcr do
    let(:created_reservations_offer_id) {
      find_resource("#{@casette_base_path}_create_reservation_offer/creates_a_new_reservations_offer.yml", "offers")[:id]
    }

    it "updates given reservations offer by ID" do
      client.patch_reservation_offer(created_reservations_offer_id, total_amount_cents: 60000)
      assert_requested :patch, bs_url("reservations/offers/#{created_reservations_offer_id}"),
        body: { reservations_offers: [{ total_amount_cents: 60000 }] }.to_json
    end

    it "returns updated reservations offer" do
      VCR.use_cassette("BookingSync_API_Client_ReservationsOffers/_patch_reservation_offer/updates_given_reservations_offer_by_ID") do
        reservations_offer = client.patch_reservation_offer(created_reservations_offer_id, total_amount_cents: 60000)
        expect(reservations_offer).to be_kind_of(BookingSync::API::Resource)
        expect(reservations_offer.total_amount_cents).to eq(60000)
      end
    end
  end

  describe ".delete_reservation_offer", :vcr do
    let(:created_reservations_offer_id) {
      find_resource("#{@casette_base_path}_create_reservation_offer/creates_a_new_reservations_offer.yml", "offers")[:id]
    }

    it "soft-cancels given reservations offer" do
      expect(client.delete_reservation_offer(created_reservations_offer_id)).to be_nil
      assert_requested :delete, bs_url("reservations/offers/#{created_reservations_offer_id}")
    end
  end
end
