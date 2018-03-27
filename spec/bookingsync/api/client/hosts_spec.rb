require "spec_helper"

describe BookingSync::API::Client::Hosts do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".hosts", :vcr do
    it "returns hosts" do
      expect(client.hosts).not_to be_empty
      assert_requested :get, bs_url("hosts")
    end
  end

  describe ".host", :vcr do
    let(:prefetched_host_id) {
      find_resource("#{@casette_base_path}_hosts/returns_hosts.yml", "hosts")[:id]
    }

    it "returns a single host" do
      host = client.host(prefetched_host_id)
      expect(host.id).to eq prefetched_host_id
    end
  end

  describe ".create_host", :vcr do
    let(:user) { BookingSync::API::Resource.new(client, id: 1) }
    let(:source) { BookingSync::API::Resource.new(client, id: 1) }
    let(:attributes) do
      {
        email: "host_email@example.com",
        firstname: "John",
        lastname: "Doe",
        user_id: user.id,
        source_id: source.id
      }
    end

    it "creates a new host" do
      client.create_host(attributes)
      assert_requested :post, bs_url("hosts"),
        body: { hosts: [attributes] }.to_json
    end

    it "returns newly created host" do
      VCR.use_cassette("BookingSync_API_Client_Hosts/_create_host/creates_a_new_host") do
        host = client.create_host(attributes)
        expect(host.email).to eq("host_email@example.com")
        expect(host.lastname).to eq("Doe")
        expect(host.firstname).to eq("John")
        expect(host.links.user).to eq(user.id)
        expect(host.links.source).to eq(source.id)
      end
    end
  end

  describe ".edit_host", :vcr do
    let(:attributes) {
      { firstname: "Johnny" }
    }
    let(:created_host_id) {
      find_resource("#{@casette_base_path}_create_host/creates_a_new_host.yml", "hosts")[:id]
    }

    it "updates given host by ID" do
      client.edit_host(created_host_id, attributes)
      assert_requested :put, bs_url("hosts/#{created_host_id}"),
        body: { hosts: [attributes] }.to_json
    end

    it "returns updated host" do
      VCR.use_cassette("BookingSync_API_Client_Hosts/_edit_host/updates_given_host_by_ID") do
        host = client.edit_host(created_host_id, attributes)
        expect(host).to be_kind_of(BookingSync::API::Resource)
        expect(host.firstname).to eq("Johnny")
      end
    end
  end
end
