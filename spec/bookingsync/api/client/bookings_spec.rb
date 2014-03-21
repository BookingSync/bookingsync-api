require "spec_helper"

describe BookingSync::API::Client::Bookings do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".bookings", :vcr do
    it "returns bookings" do
      expect(client.bookings).not_to be_nil
      assert_requested :get, bs_url("bookings")
    end

    describe "pagination" do
      context "with per_page setting" do
        it "returns limited number of bookings" do
          bookings = client.bookings(per_page: 2)
          expect(bookings.size).to eql(2)
        end
      end

      context "with a block" do
        it "yields block with batch of bookings" do
          sizes = [2, 2, 1]
          index = 0
          client.bookings(per_page: 2) do |bookings|
            expect(bookings.size).to eql(sizes[index])
            index += 1
          end
        end
      end

      context "with auto_paginate: true" do
        it "returns all bookings joined from many requests" do
          bookings = client.bookings(per_page: 2, auto_paginate: true)
          expect(bookings.size).to eql(5)
        end
      end
    end
  end

  describe ".create_booking", :vcr do
    let(:attributes) {
      {start_at: '2014-01-03', end_at: '2014-01-04', rental_id: 20,
        booked: true}
    }

    it "creates a booking" do
      client.create_booking(attributes)
      assert_requested :post, bs_url("bookings"),
        body: {bookings: [attributes]}.to_json
    end

    it "returns newly created booking" do
      VCR.use_cassette('BookingSync_API_Client_Bookings/_create_booking/creates_a_booking') do
        booking = client.create_booking(attributes)
        expect(booking.account_id).to eql(1)
        expect(booking.rental_id).to eql(20)
      end
    end
  end

  describe ".edit_booking", :vcr do
    it "updates given booking by ID" do
      client.edit_booking(50, {adults: 1})
      assert_requested :put, bs_url("bookings/50"),
        body: {bookings: [{adults: 1}]}.to_json
    end

    it "returns an empty array" do
      VCR.use_cassette('BookingSync_API_Client_Bookings/_edit_booking/updates_given_booking_by_ID') do
        expect(client.edit_booking(50, {adults: 1})).to eql([])
      end
    end

    it "updates given booking by Resource object" do
      VCR.use_cassette('BookingSync_API_Client_Bookings/_edit_booking/updates_given_booking_by_ID') do
        resource = double(to_s: "50")
        client.edit_booking(resource, {adults: 1})
        assert_requested :put, bs_url("bookings/50"),
          body: {bookings: [{adults: 1}]}.to_json
      end
    end
  end

  describe ".cancel_booking", :vcr do
    it "cancels given booking" do
      client.cancel_booking(50)
      assert_requested :delete, bs_url("bookings/50")
    end
  end
end
