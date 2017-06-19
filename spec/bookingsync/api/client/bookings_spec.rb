require "spec_helper"

describe BookingSync::API::Client::Bookings do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".bookings", :vcr do
    it "returns bookings" do
      expect(client.bookings(include_canceled: true)).not_to be_empty
      assert_requested :get, bs_url("bookings?include_canceled=true")
    end

    describe "pagination" do
      context "with per_page setting" do
        it "returns limited number of bookings" do
          bookings = client.bookings(per_page: 2)
          expect(bookings.size).to eq(2)
        end
      end

      context "with a block" do
        it "yields block with batch of bookings" do
          sizes = [2, 2]
          index = 0
          client.bookings(per_page: 2) do |bookings|
            expect(bookings.size).to eq(sizes[index])
            index += 1
          end
        end
      end

      context "with auto_paginate: true" do
        it "returns all bookings joined from many requests" do
          bookings = client.bookings(per_page: 2, auto_paginate: true)
          expect(bookings.size).to eq(4)
        end
      end
    end
  end

  describe ".booking", :vcr do
    let(:bookings) {
      find_resources("#{@casette_base_path}_bookings/returns_bookings.yml", "bookings")
    }

    it "returns a single booking" do
      prefetched_booking_id = bookings.detect { |b| b["status"] == "Booked" }["id"]
      booking = client.booking(prefetched_booking_id)
      expect(booking.status).to eq "Booked"
    end

    it "returns a single canceled booking" do
      prefetched_canceled_booking_id = bookings.detect { |b| b["status"] == "Canceled" }["id"]
      booking = client.booking(prefetched_canceled_booking_id, include_canceled: true)
      expect(booking.status).to eq "Canceled"
    end
  end

  describe ".create_booking", :vcr do
    let(:attributes) {
      { start_at: "2017-01-03", end_at: "2017-01-04",
        booked: true }
    }
    let(:rental) { BookingSync::API::Resource.new(client, id: 5116) }

    it "creates a booking" do
      client.create_booking(rental, attributes)
      assert_requested :post, bs_url("rentals/#{rental}/bookings"),
        body: { bookings: [attributes] }.to_json
    end

    it "returns newly created booking" do
      VCR.use_cassette("BookingSync_API_Client_Bookings/_create_booking/creates_a_booking") do
        booking = client.create_booking(rental, attributes)
        expect(booking.links.account).to eq(3837)
        expect(booking.links.rental).to eq(rental.id)
      end
    end
  end

  describe ".edit_booking", :vcr do
    let(:created_booking_id) {
      find_resource("#{@casette_base_path}_create_booking/creates_a_booking.yml", "bookings")[:id]
    }

    it "updates given booking by ID" do
      client.edit_booking(created_booking_id, end_at: "2019-03-25 21:45:00 UTC")
      assert_requested :put, bs_url("bookings/#{created_booking_id}"),
        body: { bookings: [{ end_at: "2019-03-25 21:45:00 UTC" }] }.to_json
    end

    it "returns updated booking" do
      VCR.use_cassette("BookingSync_API_Client_Bookings/_edit_booking/updates_given_booking_by_ID") do
        booking = client.edit_booking(created_booking_id, end_at: "2019-03-25 21:45:00 UTC")
        expect(booking).to be_kind_of(BookingSync::API::Resource)
        expect(booking.end_at).to eq(Time.parse("2019-03-25 21:45:00 UTC"))
      end
    end

    it "updates given booking by Resource object" do
      VCR.use_cassette("BookingSync_API_Client_Bookings/_edit_booking/updates_given_booking_by_ID") do
        resource = BookingSync::API::Resource.new(nil, id: created_booking_id)
        client.edit_booking(resource, end_at: "2019-03-25 21:45:00 UTC")
        assert_requested :put, bs_url("bookings/#{resource}"),
          body: { bookings: [{ end_at: "2019-03-25 21:45:00 UTC" }] }.to_json
      end
    end
  end

  describe ".cancel_booking", :vcr do
    let(:booking_id_to_be_canceled) { 796 }

    it "cancels given booking and passes options along as bookings payload" do
      client.cancel_booking(booking_id_to_be_canceled, cancelation_reason: "payment_failed")
      assert_requested :delete, bs_url("bookings/#{booking_id_to_be_canceled}"),
        body: { bookings: [{ cancelation_reason: "payment_failed" }] }.to_json
    end
  end
end
