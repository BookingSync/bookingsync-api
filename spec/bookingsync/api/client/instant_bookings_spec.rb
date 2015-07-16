require "spec_helper"

describe BookingSync::API::Client::InstantBookings do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".create_instant_booking", :vcr do
    let(:params) do
      {
        "rental_id" => "1",
        "start_at" => "2015-08-01 16:00:00",
        "end_at" => "2015-08-11 10:00:00",
        "adults" => "3",
        "children" => "2",
        "final_price" => "806.82",
        "currency" => "EUR",
        "bookings_fees_attributes" => {
          "0" => { "rentals_fee_id" => "1", "times_booked" => "1" },
          "1" => { "rentals_fee_id" => "3", "times_booked" => "1" }
        },
        "contact_information_attributes" => {
          "firstname" => "Lazar",
          "email" => "email@example.com",
          "lastname" => "Angelov",
          "phone_number" => "123-123-123",
          "country_code" => "US"
        }
      }
    end

    it "creates a booking" do
      client.create_instant_booking(params)
      assert_requested :post, bs_url("instant_bookings"),
        body: {bookings: [params]}.to_json
    end

     it "returns newly created booking" do
      VCR.use_cassette('BookingSync_API_Client_InstantBookings/_create_instant_booking/creates_a_booking') do
        booking = client.create_instant_booking(params)
        expect(booking.start_at).to eql(Time.parse("2015-08-01 16:00:00 UTC"))
        expect(booking.end_at).to eql(Time.parse("2015-08-11 10:00:00 UTC"))
      end
    end
  end
end
