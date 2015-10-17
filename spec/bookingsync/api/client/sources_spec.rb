require "spec_helper"

describe BookingSync::API::Client::Sources do

  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".sources", :vcr do
    it "returns sources" do
      expect(client.sources).not_to be_empty
      assert_requested :get, bs_url("sources")
    end
  end

  describe ".source", :vcr do
    it "returns a single source" do
      source = client.source(1874)
      expect(source.id).to eq 1874
    end
  end

  describe ".create_source", :vcr do
    let(:attributes) {
      { name: 'New source' }
    }

    it "creates a new source" do
      client.create_source(attributes)
      assert_requested :post, bs_url("sources"),
        body: { sources: [attributes] }.to_json
    end

    it "returns newly created source" do
      VCR.use_cassette('BookingSync_API_Client_Sources/_create_source/creates_a_new_source') do
        source = client.create_source(attributes)
        expect(source.name).to eql(attributes[:name])
      end
    end
  end

  describe ".edit_source", :vcr do
    let(:attributes) {
      { name: 'HomeAway.com' }
    }

    it "updates given source by ID" do
      client.edit_source(4, attributes)
      assert_requested :put, bs_url("sources/4"),
        body: { sources: [attributes] }.to_json
    end

    it "returns updated source" do
      VCR.use_cassette('BookingSync_API_Client_Sources/_edit_source/updates_given_source_by_ID') do
        source = client.edit_source(4, attributes)
        expect(source).to be_kind_of(BookingSync::API::Resource)
        expect(source.name).to eql(attributes[:name])
      end
    end
  end
end
