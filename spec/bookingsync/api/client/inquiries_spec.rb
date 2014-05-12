require "spec_helper"

describe BookingSync::API::Client::Inquiries do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".inquiries", :vcr do
    it "returns inquiries" do
      expect(client.inquiries).not_to be_empty
      assert_requested :get, bs_url("inquiries")
    end
  end

  describe ".create_inquiry", :vcr do
    let(:attributes) { {
      rental_id: 7,
      start_at:  Time.now,
      end_at:    Time.now + 86400, # one day
      firstname: "John",
      lastname:  "Smith",
      email:     "john@example.com"
    } }
    let(:rental) { BookingSync::API::Resource.new(client, id: 7) }

    it "creates a new inquiry" do
      client.create_inquiry(rental, attributes)
      assert_requested :post, bs_url("rentals/7/inquiries"),
        body: {inquiries: [attributes]}.to_json
    end

    it "returns newly created inquiry" do
      VCR.use_cassette('BookingSync_API_Client_Inquiries/_create_inquiry/creates_a_new_inquiry') do
        inquiry = client.create_inquiry(rental, attributes)
        expect(inquiry.rental_id).to eql(7)
        expect(inquiry.firstname).to eql("John")
      end
    end
  end
end
