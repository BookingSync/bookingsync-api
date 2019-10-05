require "spec_helper"

describe BookingSync::API::Client::RentalUrls do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".rental_urls", :vcr do
    it "returns rental urls" do
      expect(client.rental_urls).not_to be_empty
      assert_requested :get, bs_url("rental_urls")
    end

    describe "links" do
      it "returns associated rental" do
        rentals_url = client.rental_urls.first
        expect(rentals_url.rental).not_to be_empty
      end
    end
  end

  describe ".rental_url", :vcr do
    let(:prefetched_rental_url) {
      find_resource("#{@casette_base_path}_rental_urls/returns_rental_urls.yml", "rental_urls")[:id]
    }

    it "returns rental_url" do
      client.rental_url(prefetched_rental_url)
      assert_requested :get, bs_url("rental_urls/#{prefetched_rental_url}")
    end
  end

  describe ".create_rental_url", :vcr do
    let(:attributes) { { url: "test_test.com", label: "HomeAway", locked: "true" } }
    let(:rental) { BookingSync::API::Resource.new(client, id: 1) }

    it "creates a new rental_url" do
      client.create_rental_url(rental, attributes)
      assert_requested :post, bs_url("rentals/#{rental}/rental_urls"),
        body: { rental_urls: attributes }.to_json
    end

    it "returns newly created rental_url" do
      VCR.use_cassette("BookingSync_API_Client_RentalsAmenities/_create_rental_url/creates_a_new_rental_url") do
        rental_url = client.create_rental_url(rental, attributes)
        expect(rental_url.url).to eq("test_test.com")
        expect(rental_url.label).to eq("HomeAway")
      end
    end
  end

  describe ".edit_rental_url", :vcr do
    let(:attributes) { { url: "new_url.com" } }
    let(:created_rental_url) {
      find_resource("#{@casette_base_path}_create_rental_url/creates_a_new_rental_url.yml", "rental_urls")[:id]
    }

    it "updates given rental_url by ID" do
      client.edit_rental_url(created_rental_url, attributes)
      assert_requested :put, bs_url("rental_urls/#{created_rental_url}"),
        body: { rental_urls: attributes }.to_json
    end

    it "returns updated rental_url" do
      VCR.use_cassette("BookingSync_API_Client_RentalsAmenities/_edit_rental_url/updates_given_rentals_url_by_ID") do
        rental_url = client.edit_rental_url(created_rental_url, attributes)
        expect(rental_url).to be_kind_of(BookingSync::API::Resource)
        expect(rental_url.url).to eq("new_url.com")
      end
    end
  end
end
