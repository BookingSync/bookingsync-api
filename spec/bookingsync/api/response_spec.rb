require 'spec_helper'

describe BookingSync::API::Response do
  let(:headers) {
    {'Link' => '</rentals?page=2>; rel="next", </rentals?page=19>; rel="last"',
     'Content-Type' => 'application/json'}
  }
  let(:links) {
    {:'rentals.photos' => 'https://www.bookingsync.com/api/v3/photos/{rentals.photos}'}
  }
  let(:rentals) { [
    {id: 1, name: 'rental 1', photos: [1, 43]},
    {id: 2, name: 'rental 2'}
  ] }
  let(:response) do
    stubs = Faraday::Adapter::Test::Stubs.new
    client = BookingSync::API::Client.new(test_access_token,
      base_url: "http://foo.com") do |conn|
      conn.builder.handlers.delete(Faraday::Adapter::NetHttp)
      conn.adapter :test, @stubs do |stub|
        stub.get '/rentals' do
          body = {links: links, rentals: rentals}.to_json
          [200, headers, body]
        end
      end
    end
    client.call(:get, '/rentals')
  end

  describe "#resources_key" do
    it "returns name of the hash key where resources are" do
      expect(response.resources_key).to eql(:rentals)
    end
  end

  describe "#resources" do
    it "returns an array of resources" do
      expect(response.resources).to eql(rentals)
    end
  end

  describe "#links" do
    it "returns links to associated resources" do
      expect(response.links).to eql(links)
    end
  end

  describe "#status" do
    it "returns HTTP response status" do
      expect(response.status).to eql(200)
    end
  end

  describe "#headers" do
    it "returns HTTP response headers" do
      expect(response.headers).to eql(headers)
    end
  end

  describe "#rels" do
    it "returns relations from Link header" do
      expect(response.rels[:next].href).to eql('/rentals?page=2')
      expect(response.rels[:last].href).to eql('/rentals?page=19')
    end
  end
end
