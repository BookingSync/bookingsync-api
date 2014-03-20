require "spec_helper"

describe BookingSync::API::Client::Bookings do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".bookings", :vcr do
    it "returns bookings" do
      expect(client.bookings).not_to be_nil
      assert_requested :get, bs_url("bookings")
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
end
