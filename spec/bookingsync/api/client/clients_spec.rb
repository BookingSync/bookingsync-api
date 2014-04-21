require "spec_helper"

describe BookingSync::API::Client::Bookings do
  let(:api) { BookingSync::API::Client.new(test_access_token) }

  describe ".clients", :vcr do
    it "returns clients" do
      expect(api.clients).not_to be_nil
      assert_requested :get, bs_url("clients")
    end
  end

  describe ".create_client", :vcr do
    let(:attributes) {{
      fullname: "John Smith",
      phone: "11111111",
      mobile: "33333333",
      email: "smith@example.com",
      fax: "1111111",
      address1: "Italy",
      country_code: "IT",
      city: "Rome"
    }}

    it "creates a new client" do
      api.create_client(attributes)
      assert_requested :post, bs_url("clients"),
        body: {clients: [attributes]}.to_json
    end

    it "returns newly created client" do
      VCR.use_cassette('BookingSync_API_Client_Bookings/_create_client/creates_a_new_client') do
        client = api.create_client(attributes)
        expect(client.email).to eql("smith@example.com")
        expect(client.fullname).to eql("John Smith")
      end
    end
  end

  describe ".edit_client", :vcr do
    it "updates given client by ID" do
      api.edit_client(2, fullname: "Gary Smith")
      assert_requested :put, bs_url("clients/2"),
        body: {clients: [{fullname: "Gary Smith"}]}.to_json
    end

    it "returns updated client" do
      VCR.use_cassette('BookingSync_API_Client_Bookings/_edit_client/updates_given_client_by_ID') do
        client = api.edit_client(2, fullname: "Gary Smith")
        expect(client).to be_kind_of(Sawyer::Resource)
        expect(client.fullname).to eq("Gary Smith")
      end
    end
  end
end
