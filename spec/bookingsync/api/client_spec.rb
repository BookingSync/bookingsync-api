require "spec_helper"

describe BookingSync::API::Client do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe "#new" do
    it "initializes client object with given token" do
      client = BookingSync::API::Client.new("xyz")
      expect(client.token).to eql("xyz")
    end
  end

  describe "#get" do
    before { VCR.turn_off! }
    it "makes a HTTP GET request" do
      stub_get("resource")
      client.get("resource")
      assert_requested :get, bs_url("resource")
    end

    it "adds query options to the URL" do
      stub_get("resource?abc=123")
      client.get("resource", abc: 123)
      assert_requested :get, bs_url("resource?abc=123")
    end
  end

  describe "#post" do
    before { VCR.turn_off! }
    it "makes a HTTP POST request with body" do
      stub_post("resource")
      client.post("resource", {key: :value})
      assert_requested :post, bs_url("resource"), body: '{"key":"value"}'
    end

    context "on 422 response" do
      it "raises UnprocessableEntity exception" do
        stub_post("resource", status: 422)
        expect {
          client.post("resource", {key: :value})
        }.to raise_error(BookingSync::API::UnprocessableEntity)
      end
    end
  end

  describe "#put" do
    before { VCR.turn_off! }
    it "makes a HTTP PUT request with body" do
      stub_put("resource")
      client.put("resource", {key: :value})
      assert_requested :put, bs_url("resource"), body: '{"key":"value"}'
    end
  end

  describe "#delete" do
    before { VCR.turn_off! }
    it "makes a HTTP DELETE request" do
      stub_delete("resource")
      client.delete("resource")
      assert_requested :delete, bs_url("resource")
    end
  end

  describe "#request" do
    before { VCR.turn_off! }
    it "authenticates the request with OAuth token" do
      ENV["ACCESS_TOKEN"] = nil
      stub_get("resource")
      client.get("resource")
      assert_requested :get, bs_url("resource"),
        headers: {"Authorization" => "Bearer fake-access-token"}
    end

    it "requests proper accept header for JSON API" do
      stub_get("resource")
      client.get("resource")
      assert_requested :get, bs_url("resource"),
        headers: {"Accept" => "application/vnd.api+json"}
    end

    it "requests sends data with JSON API content type" do
      stub_post("resource")
      client.post("resource")
      assert_requested :post, bs_url("resource"),
        headers: {"Content-Type" => "application/vnd.api+json"}
    end

    it "returns Array of resources" do
      stub_get("resource", body: {resources: [{name: "Megan"}]}.to_json)
      resources = client.get("resource")
      expect(resources.size).to eq(1)
      expect(resources.first.name).to eq("Megan")
    end

    context "API returns 401" do
      it "raises Unauthorized exception" do
        stub_get("resource", status: 401)
        expect {
          client.get("resource")
        }.to raise_error(BookingSync::API::Unauthorized)
      end
    end

    context "API returns status code outside 200..299 range" do
      it "returns nil" do
        stub_get("resource", status: 404)
        expect(client.get("resource")).to be_nil
      end
    end

    context "API returns 204 No Content" do
      it "returns an empty array" do
        stub_get("resource", status: 204)
        expect(client.get("resource")).to eql([])
      end
    end

    context "user wants to fetch only specific fields" do
      it "constructs url for filtered fields" do
        stub_get("resource?fields=name,description")
        client.get("resource", fields: [:name, :description])
        assert_requested :get, bs_url("resource?fields=name,description")
      end
    end

    context "user passes additional query options" do
      it "constructs url with query options" do
        stub_get("resource?months=12&status=booked,unavailable")
        client.get("resource", status: [:booked, :unavailable], months: '12')
        assert_requested :get, bs_url("resource?months=12&status=booked,unavailable")
      end
    end
  end

  describe "#api_endpoint" do
    it "returns URL to the API" do
      ENV["BOOKINGSYNC_URL"] = nil
      expect(client.api_endpoint).to eql("https://www.bookingsync.com/api/v3")
    end

    context "user specifies base URL via BOOKINGSYNC_URL env" do
      it "returns custom URL to the API" do
        ENV["BOOKINGSYNC_URL"] = "https://bookingsync.dev"
        expect(client.api_endpoint).to eql("https://bookingsync.dev/api/v3")
      end
    end
  end
end
