require "spec_helper"

describe BookingSync::API::Error do
  let(:client) { BookingSync::API::Client.new(test_access_token) }
  before do
    stub_get("resource", status: 422, body:
      { errors: { name: ["can't be blank"] } }.to_json)
  end
  let(:request) { client.get("resource") }

  describe "#status" do
    it "returns HTTP status of the response" do
      expect { request }.to raise_error(BookingSync::API::Error) { |exception|
        expect(exception.status).to eq 422
      }
    end
  end

  describe "#body" do
    it "returns response body" do
      expect { request }.to raise_error(BookingSync::API::Error) { |exception|
        expect(exception.body).to eq '{"errors":{"name":["can\'t be blank"]}}'
      }
    end
  end

  describe "#headers" do
    it "returns response headers" do
      expect { request }.to raise_error(BookingSync::API::Error) { |exception|
        expect(exception.headers).to eq({"content-type" =>
          "application/vnd.api+json"})
      }
    end
  end

  describe "#message" do
    it "returns standard exception message" do
      expect { request }.to raise_error(BookingSync::API::Error) { |exception|
        expect(exception.message).to eq(%Q{BookingSync::API::UnprocessableEntity
HTTP status code : 422
Headers          : {"content-type"=>"application/vnd.api+json"}
Body             : {"errors":{"name":["can't be blank"]}}})
      }
    end
  end
end
