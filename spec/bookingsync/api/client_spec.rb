require "spec_helper"

describe BookingSync::API::Client do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe "#new" do
    it "initializes client object with given token" do
      client = BookingSync::API::Client.new("xyz")
      expect(client.token).to eq("xyz")
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
      client.post("resource", key: :value)
      assert_requested :post, bs_url("resource"), body: '{"key":"value"}'
    end

    context "on 422 response" do
      it "raises UnprocessableEntity exception" do
        stub_post("resource", status: 422, body: { errors: { country_code:
          ["is required"] } }.to_json)
        expect {
          client.post("resource", key: :value)
        }.to raise_error(BookingSync::API::UnprocessableEntity) { |error|
          expect(error.message).to include '{"errors":{"country_code":["is required"]}}'
        }
      end
    end
  end

  describe "#put" do
    before { VCR.turn_off! }
    it "makes a HTTP PUT request with body" do
      stub_put("resource")
      client.put("resource", key: :value)
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
    context "on response which responds to :resources" do
      it "returns an array of resources" do
        stub_get("resource", body: { resources: [{ name: "Megan" }] }.to_json)
        resources = client.request(:get, "resource")
        expect(resources).to be_kind_of(Array)
        expect(resources.first.name).to eq("Megan")
      end
    end

    context "on response which doesn't respond to :resources" do
      it "returns response" do
        stub_get("resource", status: 204)
        response = double(BookingSync::API::Response)
        allow(client).to receive(:call) { response }
        resources = client.request(:get, "resource")
        expect(resources).to eq(response)
      end
    end
  end

  describe "#call" do
    before { VCR.turn_off! }
    it "authenticates the request with OAuth token" do
      ENV["ACCESS_TOKEN"] = nil
      stub_get("resource")
      client.call(:get, "resource")
      assert_requested :get, bs_url("resource"),
        headers: { "Authorization" => "Bearer fake-access-token" }
    end

    it "requests proper accept header for JSON API" do
      stub_get("resource")
      client.call(:get, "resource")
      assert_requested :get, bs_url("resource"),
        headers: { "Accept" => "application/vnd.api+json" }
    end

    it "requests sends data with JSON API content type" do
      stub_post("resource")
      client.call(:post, "resource")
      assert_requested :post, bs_url("resource"),
        headers: { "Content-Type" => "application/vnd.api+json" }
    end

    it "returns an Response object of resources" do
      attributes = { resources: [{ name: "Megan" }] }
      stub_post("resource", body: attributes.to_json)
      response = client.call(:post, "resource", attributes)
      expect(response).to be_kind_of(BookingSync::API::Response)
    end

    it "requests with proper User-Agent" do
      stub_get("resource", body: {}.to_json)
      client.call(:get, "resource")
      assert_requested :get, bs_url("resource"),
        headers: { "User-Agent" =>
          "BookingSync API gem v#{BookingSync::API::VERSION}" }
    end

    context "API returns 401" do
      it "raises Unauthorized exception" do
        stub_get("resource", status: 401)
        expect {
          client.get("resource")
        }.to raise_error(BookingSync::API::Unauthorized)
      end
    end

    context "API returns 403" do
      it "raises Unauthorized exception" do
        stub_get("resource", status: 403)
        expect {
          client.get("resource")
        }.to raise_error(BookingSync::API::Forbidden)
      end
    end

    context "API returns 404" do
      it "raises NotFound exception" do
        stub_get("resource", status: 404)
        expect {
          client.get("resource")
        }.to raise_error(BookingSync::API::NotFound)
      end
    end

    context "API returns 429" do
      it "raises RateLimitExceeded exception" do
        stub_get("resource", status: 429)
        expect {
          client.get("resource")
        }.to raise_error(BookingSync::API::RateLimitExceeded)
      end
    end

    context "API returns unsupported status code outside 200..299 range" do
      it "raises UnsupportedResponse exception" do
        stub_get("resource", status: 405, body: "Whoops!",
          headers: { "content-type" => "application/vnd.api+json" })
        expect {
          client.get("resource")
        }.to raise_error(BookingSync::API::UnsupportedResponse) { |error|
          expect(error.status).to eq(405)
          expect(error.headers).to eq("content-type" => "application/vnd.api+json")
          expect(error.body).to eq("Whoops!")
          expect(error.message).to include("Received unsupported response from BookingSync API")
        }
      end
    end

    context "API returns 204 No Content" do
      it "returns nil" do
        stub_get("resource", status: 204)
        expect(client.get("resource")).to be_nil
      end
    end

    context "user wants to fetch only specific fields" do
      it "constructs url for filtered fields" do
        stub_get("resource?fields=name,description")
        client.get("resource", fields: [:name, :description])
        assert_requested :get, bs_url("resource?fields=name,description")
      end

      it "should support single field" do
        stub_get("resource?fields=name")
        client.get("resource", fields: :name)
        assert_requested :get, bs_url("resource?fields=name")
      end
    end

    context "user wants to fetch only specific ids" do
      it "constructs url for given ids" do
        stub_get("resources/1,3,4")
        client.get("resources", ids: [1, 3, 4])
        assert_requested :get, bs_url("resources/1,3,4")
      end
    end

    context "user passes additional query options" do
      it "constructs url with query options" do
        stub_get("resource?months=12&status=booked,unavailable")
        client.get("resource", status: [:booked, :unavailable], months: "12")
        assert_requested :get, bs_url("resource?months=12&status=booked,unavailable")
      end
    end
  end

  describe "#api_endpoint" do
    it "returns URL to the API" do
      ENV["BOOKINGSYNC_URL"] = nil
      expect(client.api_endpoint).to eq("https://www.bookingsync.com/api/v3")
    end

    context "user specifies base URL via BOOKINGSYNC_URL env" do
      before do
        ENV["BOOKINGSYNC_URL"] = "https://bookingsync.dev"
      end

      after do
        ENV["BOOKINGSYNC_URL"] = nil
      end

      it "returns custom URL to the API" do
        expect(client.api_endpoint).to eq("https://bookingsync.dev/api/v3")
      end
    end
  end

  describe "logging" do
    before { VCR.turn_off! }
    let(:log) { StringIO.new }
    let(:logger) { Logger.new(log) }

    it "uses logger provided by user" do
      client = BookingSync::API::Client.new(test_access_token, logger: logger)
      stub_get("resources", body: { "resources" => [{ id: 1 }, { id: 2 }] }.to_json)
      client.get("resources")
      messages = log.rewind && log.read
      expect(messages).to include("GET https://www.bookingsync.com/api/v3/resources")
    end

    context "BOOKINGSYNC_API_DEBUG env variable set to true" do
      after { ENV["BOOKINGSYNC_API_DEBUG"] = "false" }
      it "uses STDOUT as logs output" do
        ENV["BOOKINGSYNC_API_DEBUG"] = "true"
        expect(Logger).to receive(:new).with(STDOUT).and_return(logger)
        stub_get("resources")
        client.get("resources")

        messages = log.rewind && log.read
        expect(messages).to include("GET https://www.bookingsync.com/api/v3/resources")
      end
    end

    it "logs X-Request-Id from headers" do
      client = BookingSync::API::Client.new(test_access_token, logger: logger)
      stub_get("resources", body: {}.to_json,
        headers: { "X-Request-Id" => "021bfb82" })
      client.get("resources")

      messages = log.rewind && log.read
      expect(messages).to include("Response X-Request-Id: 021bfb82 GET https://www.bookingsync.com/api/v3/resources")
    end
  end

  describe "#last_response" do
    it "returns last response" do
      stub_get("resources", body: { meta: { count: 10 }, resources: [] }.to_json)
      client.get("resources")
      expect(client.last_response.meta).to eq(count: 10)
    end
  end

  context "pagination" do
    before do
      stub_get("resources", headers: { "Link" => '<resources?page=2>; rel="next"' }, body: { meta: { text: "first request" }, resources: [] }.to_json)
      stub_get("resources?page=2", body: { meta: { text: "second request" }, resources: [] }.to_json)
    end

    describe "#pagination_first_response" do
      it "returns first response of a paginated call" do
        client.paginate("resources", auto_paginate: true)
        expect(client.pagination_first_response.meta).to eq(text: "first request")
      end
    end

    describe "with block" do
      before do
        stub_get("resources?per_page=50", headers: {}, body: { meta: { text: "first request" }, resources: [{ id: 1 }] }.to_json)
      end

      context "when there is only one page with results" do
        it "invokes block" do
          block = double("block")
          expect(block).to receive(:do_stuff)
          client.paginate("resources", per_page: 50) do |batch|
            block.do_stuff
          end
        end
      end
    end
  end

  describe "with_headers" do
    it "makes request with modified headers but resets to original headers at the end" do
      stub_get("resource")
      client.with_headers("x-awesome-header" => "you-bet-i-am") do |adjusted_api_client|
        adjusted_api_client.get("resource")
      end
      assert_requested(:get, bs_url("resource")) do |request|
        request.headers["X-Awesome-Header"] == "you-bet-i-am"
      end

      client.get("resource")
      assert_requested(:get, bs_url("resource")) do |request|
        !request.headers.key?("X-Awesome-Header")
      end
    end

    it "properly brings back original headers even if it was overriden" do
      stub_get("resource")
      client.with_headers("Content-Type" => "another-content-type") do |adjusted_api_client|
        adjusted_api_client.get("resource")
      end
      assert_requested(:get, bs_url("resource")) do |request|
        request.headers["Content-Type"] == "another-content-type"
      end

      client.get("resource")
      assert_requested(:get, bs_url("resource")) do |request|
        request.headers["Content-Type"] == BookingSync::API::Client::MEDIA_TYPE
      end
    end

    it "returns result of method called on adjusted client" do
      stub_get("resource", body: { resources: [{ name: "Megan" }] }.to_json)
      resources = client.with_headers("x-awesome-header" => "you-bet-i-am") do |adjusted_api_client|
        adjusted_api_client.get("resource")
      end
      expect(resources).to be_kind_of(Array)
      expect(resources.first).to be_a BookingSync::API::Resource
      expect(resources.first.name).to eq("Megan")
    end
  end
end
