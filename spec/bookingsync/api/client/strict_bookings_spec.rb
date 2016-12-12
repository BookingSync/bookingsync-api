require "spec_helper"

describe BookingSync::API::Client::StrictBookings do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".create_strict_booking", :vcr do
    let(:params) do
      {
        "rental_id" => 25938,
        "start_at" => "2017-05-22 16:00:00",
        "end_at" => "2017-05-29 10:00:00",
        "adults" => 3,
        "children" => 2,
        "final_price" => "63",
        "price_to_pay_now" => "18.9",
        "currency" => "EUR",
        "source_id" => "4504",
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
        body: { bookings: [params] }.to_json
    end

    it "returns newly created booking" do
     VCR.use_cassette("BookingSync_API_Client_StrictBookings/_create_strict_booking/creates_a_booking") do
       booking = client.create_strict_booking(params)
       expect(booking.start_at).to eql(Time.parse("2017-05-22 16:00:00 UTC"))
       expect(booking.end_at).to eql(Time.parse("2017-05-29 10:00:00 UTC"))
     end
   end
  end
end
