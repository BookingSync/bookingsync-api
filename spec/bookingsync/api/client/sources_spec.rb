require "spec_helper"

describe BookingSync::API::Client::Sources do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".sources", :vcr do
    it "returns sources" do
      expect(client.sources).not_to be_empty
      assert_requested :get, bs_url("sources")
    end
  end

  describe ".source", :vcr do
    let(:prefetched_source_id) {
      find_resource("#{@casette_base_path}_sources/returns_sources.yml", "sources")[:id]
    }

    it "returns a single source" do
      source = client.source(prefetched_source_id)
      expect(source.id).to eq prefetched_source_id
    end
  end

  describe ".create_source", :vcr do
    let(:attributes) {
      { name: "New source" }
    }

    it "creates a new source" do
      client.create_source(attributes)
      assert_requested :post, bs_url("sources"),
        body: { sources: [attributes] }.to_json
    end

    it "returns newly created source" do
      VCR.use_cassette("BookingSync_API_Client_Sources/_create_source/creates_a_new_source") do
        source = client.create_source(attributes)
        expect(source.name).to eq(attributes[:name])
      end
    end
  end

  describe ".edit_source", :vcr do
    let(:attributes) {
      { name: "another test source" }
    }
    let(:created_source_id) {
      find_resource("#{@casette_base_path}_create_source/creates_a_new_source.yml", "sources")[:id]
    }

    it "updates given source by ID" do
      client.edit_source(created_source_id, attributes)
      assert_requested :put, bs_url("sources/#{created_source_id}"),
        body: { sources: [attributes] }.to_json
    end

    it "returns updated source" do
      VCR.use_cassette("BookingSync_API_Client_Sources/_edit_source/updates_given_source_by_ID") do
        source = client.edit_source(created_source_id, attributes)
        expect(source).to be_kind_of(BookingSync::API::Resource)
        expect(source.name).to eq(attributes[:name])
      end
    end
  end
end
