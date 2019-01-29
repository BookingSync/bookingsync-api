require "spec_helper"

describe BookingSync::API::Client::Applications do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".applications", :vcr do
    it "returns applications" do
      expect(client.applications).not_to be_empty
      assert_requested :get, bs_url("applications")
    end
  end

  describe ".application", :vcr do
    let(:prefetched_application_id) {
      find_resource("#{@casette_base_path}_applications/returns_applications.yml", "applications")[:id]
    }

    it "returns a single application" do
      application = client.application(prefetched_application_id)
      expect(application.id).to eq prefetched_application_id
    end
  end

  describe ".edit_application", :vcr do
    let(:prefetched_application_id) {
      find_resource("#{@casette_base_path}_applications/returns_applications.yml", "applications")[:id]
    }
    let(:default_price_increase) { 1.1 }

    it "updates given application by ID" do
      client.edit_application(prefetched_application_id, default_price_increase: default_price_increase)
      assert_requested :put, bs_url("applications/#{prefetched_application_id}"),
        body: { applications: [{ default_price_increase: default_price_increase }] }.to_json
    end

    it "returns updated application" do
      application = client.edit_application(prefetched_application_id, default_price_increase: default_price_increase)
      expect(application).to be_kind_of(BookingSync::API::Resource)
      expect(application.default_price_increase).to eq(default_price_increase.to_s)
    end
  end
end
