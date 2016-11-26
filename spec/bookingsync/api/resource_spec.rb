require "spec_helper"

describe BookingSync::API::Resource do
  let(:links) { { photos: [9, 10] } }
  let(:relation) {
    BookingSync::API::Relation.from_links(client,
      :"foo.photos" => "http://foo.com/photos/{foo.photos}", # rubocop:disable Style/HashSyntax
      :"foo.category" => "http://foo.com/categories/{foo.category}", # rubocop:disable Style/HashSyntax
      :"foo.article" => "http://foo.com/articles/{foo.taggable.id}") # rubocop:disable Style/HashSyntax
  }
  let(:client) { BookingSync::API::Client.new(test_access_token,
    base_url: "http://foo.com")
  }
  let(:data) do
    {
      name: "foo",
      width: 700,
      links: links,
      details: { count: 1 },
      id: 10
    }
  end
  let(:resource) {
    BookingSync::API::Resource.new(client, data, relation, "foo")
  }

  describe "processing values" do
    it "makes data accessible" do
      expect(resource.name).to eql("foo")
      expect(resource.width).to eql(700)
    end

    it "makes nested data accessible" do
      expect(resource.details.count).to eql(1)
    end

    describe "#_resources_key" do
      it "returns resources_key" do
        expect(resource._resources_key).to eql("foo")
      end

      context "for nested resource" do
        it "returns nil" do
          expect(resource.details._resources_key).to be_nil
        end
      end
    end
  end

  describe "associations" do
    before { VCR.turn_off! }

    context "has_many (ids given as an array)" do
      it "fetches an association based on links" do
        stub_request(:get, "http://foo.com/photos/9,10")
          .to_return(body: { photos: [{ file: "a.jpg" }] }.to_json)
        expect(resource.photos).to eql([{ file: "a.jpg" }])
      end
    end

    context "has_one (id given as a single integer)" do
      let(:links) { { category: 15 } }
      it "fetches an association based on links" do
        stub_request(:get, "http://foo.com/categories/15")
          .to_return(body: { categories: [{ name: "Secret one" }] }.to_json)
        expect(resource.category).to eql([{ name: "Secret one" }])
      end
    end

    context "polymorphic association" do
      let(:links) do
        { taggable: { "type" => "Article", "id" => "15" },
          other_polymorphable: { "type" => "Other", "id" => "15" },
          category: 15  }
      end
      it "fetches association based on links and type" do
        stub_request(:get, "http://foo.com/articles/15")
          .to_return(body: { articles: [{ name: "Secret one" }] }.to_json)
        expect(resource.taggable).to eql([{ name: "Secret one" }])
      end
    end

    context "when there are not associated ids" do
      let(:links) { { photos: [] } }
      it "returns an empty array" do
        expect(resource.photos).to eql([])
      end
    end

    context "association doesn't exist" do
      it "raises NoMethodError" do
        expect { resource.pphotos }.to raise_error(NoMethodError)
      end
    end

    it "passes query option to request" do
      stub_request(:get, "http://foo.com/photos/9,10?fields=description")
        .to_return(body: { photos: [{ file: "a.jpg" }] }.to_json)
      resource.photos(fields: :description)
    end

    context "when association loaded by eager loading" do
      let(:data) { { links: links, photos: [{ file: "b.jpg" }] } }

      it "doesn't fetch it again" do
        resource.photos
        assert_not_requested :get, "http://foo.com/photos/9,10"
      end

      it "returns previously loaded data" do
        expect(resource.photos).to eq([{ file: "b.jpg" }])
      end
    end
  end

  describe "#to_s" do
    it "returns resource id" do
      expect("#{resource}").to eq("10")
    end
  end
end
