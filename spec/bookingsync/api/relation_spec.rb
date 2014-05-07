require 'spec_helper'

describe BookingSync::API::Relation do
  before { VCR.turn_off! }
  let(:client) { BookingSync::API::Client.new(test_access_token,
    base_url: "http://example.com") }
  let(:links) { {"foo.photos" => "http://example.com/photos/{foo.photos}"} }
  let(:relation) { BookingSync::API::Relation.new(client, :"foo.photos",
    "http://example.com/photos/{foo.photos}") }

  describe ".from_links" do
    it "returns a hash of relations" do
      relations = BookingSync::API::Relation.from_links(client, links)
      expect(relations.size).to eql(1)
      expect(relations).to be_kind_of(Hash)
      expect(relations["foo.photos"]).to be_kind_of(BookingSync::API::Relation)
    end
  end

  describe ".from_link" do
    it "returns a single relation" do
      relation = BookingSync::API::Relation.from_link(client, :example,
        href: "https://example.com/photos")
      expect(relation).to be_kind_of(BookingSync::API::Relation)
    end
  end

  describe "#call" do
    let(:client) { double(BookingSync::API::Client) }

    it "makes HTTP request using API client" do
      url_template = Addressable::Template.new("http://example.com/photos/{foo.photos}")
      expect(client).to receive(:call).with(:get, url_template, nil, {})
      relation.call
    end
  end

  describe "#get" do
    it "makes a HTTP GET using call on relation" do
      url_template = Addressable::Template.new("http://example.com/photos/{foo.photos}")
      expect(relation).to receive(:call).with({fields: [:name, :description], method: :get})
      relation.get(fields: [:name, :description])
    end
  end


  describe "#name" do
    it "returns relation name" do
      expect(relation.name).to eq(:"foo.photos")
    end
  end

  describe "#href_template" do
    it "returns relation's URL template" do
      url_template = Addressable::Template.new("http://example.com/photos/{foo.photos}")
      expect(relation.href_template).to eq(url_template)
    end
  end

  describe "#href" do
    it "returns relation's URL" do
      expect(relation.href).to eq("http://example.com/photos/")
    end

    context "when options given" do
      it "returns relation's URL expanded" do
        url = relation.href("foo.photos" => [1, 2, 100])
        expect(url).to eq("http://example.com/photos/1,2,100")
      end
    end
  end
end
