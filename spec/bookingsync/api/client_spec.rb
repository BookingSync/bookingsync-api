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
  end

  describe "#request" do
    before { VCR.turn_off! }
    it "authenticates the request with OAuth token" do
      stub_get("resource")
      client.get("resource")
      assert_requested :get, bs_url("resource"),
        headers: {"Authorization" => "Bearer fake-access-token"}
    end

    it "requests proper content type for JSON API" do
      stub_get("resource")
      client.get("resource")
      assert_requested :get, bs_url("resource"),
        headers: {"Accept" => "application/vnd.api+json"}
    end

    it "returns Array of resources" do
      stub_get("resource", body: {resources: [{name: "Megan"}]}.to_json)
      resources = client.get("resource")
      expect(resources.size).to eq(1)
      expect(resources.first.name).to eq("Megan")
    end

    context "status code is outside 200..299 range" do
      it "returns nil" do
        stub_get("resource", status: 404)
        expect(client.get("resource")).to be_nil
      end
    end
  end

  describe "#api_endpoint" do
    it "returns URL to the API" do
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
