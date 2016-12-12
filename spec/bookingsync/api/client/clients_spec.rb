require "spec_helper"

describe BookingSync::API::Client::Clients do
  let(:api) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".clients", :vcr do
    it "returns clients" do
      expect(api.clients).not_to be_empty
      assert_requested :get, bs_url("clients")
    end
  end

  describe ".client", :vcr do
    let(:prefetched_client_id) {
      find_resource("#{@casette_base_path}_clients/returns_clients.yml", "clients")[:id]
    }

    it "returns a single client" do
      client = api.client(prefetched_client_id)
      expect(client.id).to eq prefetched_client_id
    end
  end

  describe ".create_client", :vcr do
    let(:attributes) do
      {
        fullname: "Halldor Helgason",
        emails: [{ label: "default", email: "halldor@example.com" }],
        country_code: "IS",
        city: "Reykjavik"
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
        expect(client.emails).to eq [{ label: "default", email: "halldor@example.com" }]
        expect(client.fullname).to eq ("Halldor Helgason")
      end
    end
  end

  describe ".edit_client", :vcr do
    let(:created_client_id) {
      find_resource("#{@casette_base_path}_create_client/creates_a_new_client.yml", "clients")[:id]
    }

    it "updates given client by ID" do
      api.edit_client(created_client_id, fullname: "Knut Eljassen")
      assert_requested :put, bs_url("clients/#{created_client_id}"),
        body: { clients: [{ fullname: "Knut Eljassen" }] }.to_json
    end

    it "returns updated client" do
      VCR.use_cassette("BookingSync_API_Client_Clients/_edit_client/updates_given_client_by_ID") do
        client = api.edit_client(created_client_id, fullname: "Knut Eljassen")
        expect(client).to be_kind_of(BookingSync::API::Resource)
        expect(client.fullname).to eq("Knut Eljassen")
      end
    end
  end
end
