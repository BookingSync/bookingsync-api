require "spec_helper"

describe BookingSync::API::Client::Clients do
  let(:api) { BookingSync::API::Client.new(test_access_token) }

  describe ".clients", :vcr do
    it "returns clients" do
      expect(api.clients).not_to be_empty
      assert_requested :get, bs_url("clients")
    end
  end

  describe ".client", :vcr do
    it "returns a single client" do
      client = api.client(77703)
      expect(client.id).to eq 77703
    end
  end

  describe ".create_client", :vcr do
    let(:attributes) do
      {
        fullname: "John Smith",
        emails: [{ label: "default", email: "smith@example.com" }],
        country_code: "IT",
        city: "Rome"
      }
    end

    it "creates a new client" do
      api.create_client(attributes)
      assert_requested :post, bs_url("clients"),
        body: { clients: [attributes] }.to_json
    end

    it "returns newly created client" do
      VCR.use_cassette("BookingSync_API_Client_Clients/_create_client/creates_a_new_client") do
        client = api.create_client(attributes)
        expect(client.emails).to eq [{ label: "default", email: "smith@example.com" }]
        expect(client.fullname).to eq ("John Smith")
      end
    end
  end

  describe ".edit_client", :vcr do
    it "updates given client by ID" do
      api.edit_client(77703, fullname: "Gary Smith")
      assert_requested :put, bs_url("clients/77703"),
        body: { clients: [{ fullname: "Gary Smith" }] }.to_json
    end

    it "returns updated client" do
      VCR.use_cassette("BookingSync_API_Client_Clients/_edit_client/updates_given_client_by_ID") do
        client = api.edit_client(77703, fullname: "Gary Smith")
        expect(client).to be_kind_of(BookingSync::API::Resource)
        expect(client.fullname).to eq("Gary Smith")
      end
    end
  end
end
