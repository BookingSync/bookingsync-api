require "spec_helper"

describe BookingSync::API::Client::Inquiries do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".inquiries", :vcr do
    it "returns inquiries" do
      expect(client.inquiries).not_to be_empty
      assert_requested :get, bs_url("inquiries")
    end
  end

  describe ".inquiry", :vcr do
    let(:prefetched_inquiry_id) {
      find_resource("#{@casette_base_path}_inquiries/returns_inquiries.yml", "inquiries")[:id]
    }

    it "returns a single inquiry" do
      inquiry = client.inquiry(prefetched_inquiry_id)
      expect(inquiry.id).to eq prefetched_inquiry_id
    end
  end

  describe ".create_inquiry", :vcr do
    let(:attributes) do
      {
        start_at:  Time.now,
        end_at:    Time.now + 86400, # one day
        firstname: "John",
        lastname:  "Smith",
        email:     "john@example.com"
      }
    end
    let(:rental) { BookingSync::API::Resource.new(client, id: 5116) }


    it "creates a new inquiry" do
      client.create_inquiry(rental, attributes)
      assert_requested :post, bs_url("rentals/#{rental}/inquiries"),
        body: { inquiries: [attributes] }.to_json
    end

    it "returns newly created inquiry" do
      VCR.use_cassette("BookingSync_API_Client_Inquiries/_create_inquiry/creates_a_new_inquiry") do
        inquiry = client.create_inquiry(rental, attributes)
        expect(inquiry.links.rental).to eql(rental.id)
        expect(inquiry.firstname).to eql("John")
      end
    end
  end
end
