require "spec_helper"

describe BookingSync::API::Client::StrictBookings do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".create_strict_booking", :vcr do
    let(:params) do
      {
        "rental_id" => "1",
        "start_at" => "2016-01-15 16:00:00",
        "end_at" => "2016-01-23 10:00:00",
        "adults" => "3",
        "children" => "2",
        "final_price" => "2125.42",
        "price_to_pay_now" => "2125.42",
        "currency" => "EUR",
        "source_id" => "1",
        "bookings_fees" => [
          { "rentals_fee_id" => "1", "times_booked" => "1" },
          { "rentals_fee_id" => "3", "times_booked" => "1" }
        ],
        "client" => {
          "firstname" => "Lazar",
          "email" => "email@example.com",
          "lastname" => "Angelov",
          "phone_number" => "123-123-123",
          "country_code" => "US"
        },
        "comments" => [
          { "content" => "some content" }
        ]
      }
    end

    it "creates a booking" do
      client.create_strict_booking(params)
      assert_requested :post, bs_url("strict_bookings"),
        body: {bookings: [params]}.to_json
    end

     it "returns newly created booking" do
      VCR.use_cassette('BookingSync_API_Client_StrictBookings/_create_strict_booking/creates_a_booking') do
        booking = client.create_strict_booking(params)
        expect(booking.start_at).to eql(Time.parse("2016-01-15 16:00:00 UTC"))
        expect(booking.end_at).to eql(Time.parse("2016-01-23 10:00:00 UTC"))
      end
    end
  end
end
