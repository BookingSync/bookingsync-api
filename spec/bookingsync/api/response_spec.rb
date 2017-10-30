require "spec_helper"

describe BookingSync::API::Response do
  let(:headers) {
    { "Link" => '</rentals?page=2>; rel="next", </rentals?page=19>; rel="last"',
      "Content-Type" => "application/json" }
  }
  let(:links) {
    { :"rentals.photos" => "https://www.bookingsync.com/api/v3/photos/{rentals.photos}" } # rubocop:disable Style/HashSyntax
  }
  let(:resource_relations) { BookingSync::API::Relation.from_links(client,
    links)
  }
  let(:rentals) do
    [{ id: 1, name: "rental 1", photos: [1, 43] },
     { id: 2, name: "rental 2" }]
  end
  let(:client) do
    BookingSync::API::Client.new(test_access_token,
      base_url: "http://foo.com") do |conn|
      conn.builder.handlers.delete(Faraday::Adapter::NetHttpPersistent)
      conn.adapter :test, @stubs do |stub|
        stub.get "/rentals" do
          body = { links: links, rentals: rentals,
                   meta: { count: 10 } }.to_json
          [200, headers, body]
        end
      end
    end
  end
  let(:response) do
    Faraday::Adapter::Test::Stubs.new
    client.call(:get, "/rentals")
  end

  describe "#resources_key" do
    it "returns name of the hash key where resources are" do
      expect(response.resources_key).to eq(:rentals)
    end
  end

  describe "#resources" do
    it "returns an array of resources" do
      expect(response.resources).to eq(rentals)
    end
  end

  describe "#resource_relations" do
    it "returns links to associated resources" do
      href = response.resource_relations[:"rentals.photos"].href
      expect(href).not_to be_nil
      expect(href).to eq(resource_relations[:"rentals.photos"].href)
    end
  end

  describe "#status" do
    it "returns HTTP response status" do
      expect(response.status).to eq(200)
    end
  end

  describe "#headers" do
    it "returns HTTP response headers" do
      expect(response.headers).to eq(headers)
    end
  end

  describe "#relations" do
    it "returns relations from Link header" do
      expect(response.relations[:next].href).to eq("/rentals?page=2")
      expect(response.relations[:last].href).to eq("/rentals?page=19")
    end
  end

  describe "#meta" do
    it "returns meta information from response body" do
      expect(response.meta).to eq(count: 10)
    end
  end
end
