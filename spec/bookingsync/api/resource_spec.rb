require 'spec_helper'

describe BookingSync::API::Resource do
  let(:links) { {photos: [9, 10]} }
  let(:resource) {
    client = BookingSync::API::Client.new(test_access_token,
      base_url: "http://foo.com")
    BookingSync::API::Resource.new(client,
      {
        name: "foo", width: 700,
        links: links,
        details: {count: 1}
      },
      {
        :"foo.photos" => "http://foo.com/photos/{foo.photos}",
        :"foo.bars" => "http://foo.com/bars/{foo.bars}"
      },
      "foo"
    )
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
    it "fetches an association based on links" do
      stub_request(:get, "http://foo.com/photos/9,10")
        .to_return(body: {photos: [{file: 'a.jpg'}]}.to_json)
      expect(resource.photos).to eql([{:file => "a.jpg"}])
    end

    context "when there are not associated ids" do
      let(:links) { {photos: []} }
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
        .to_return(body: {photos: [{file: 'a.jpg'}]}.to_json)
      resource.photos(fields: :description)
    end
  end
end
