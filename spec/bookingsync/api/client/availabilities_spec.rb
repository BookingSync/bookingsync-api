require "spec_helper"

describe BookingSync::API::Client::Availabilities do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".availabilities", :vcr do
    it "returns availabilities" do
      expect(client.availabilities).not_to be_empty
      assert_requested :get, bs_url("availabilities")
    end
  end

  describe ".availability", :vcr do
    let(:prefetched_availability_id) {
      find_resource("#{@casette_base_path}_availabilities/returns_availabilities.yml", "availabilities")[:id]
    }

    it "returns a single availability" do
      availability = client.availability(prefetched_availability_id)
      expect(availability.id).to eq prefetched_availability_id
    end
  end
end
