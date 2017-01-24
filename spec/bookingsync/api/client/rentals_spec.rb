require "spec_helper"

describe BookingSync::API::Client::Rentals do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".rentals", :vcr do
    it "returns rentals" do
      expect(client.rentals).not_to be_empty
      assert_requested :get, bs_url("rentals")
    end

    it "returns rentals by ids" do
      rental_ids = find_resources("#{@casette_base_path}_rentals/returns_rentals.yml", "rentals").map { |r| r["id"] }[0..1]

      rentals = client.rentals(ids: rental_ids)
      expect(rentals.size).to eq(2)
      assert_requested :get, bs_url("rentals/#{rental_ids.join(',')}")
    end

    describe "links" do
      it "returns associated photos" do
        rental = client.rentals.first
        expect(rental.photos).not_to be_empty
      end
    end
  end

  describe ".rentals_search", :vcr do
    it "returns rentals" do
      expect(client.rentals_search(start_at: "2016-12-15", end_at: "2016-12-22")).not_to be_empty
      assert_requested :post, bs_url("rentals/search"),
        body: { start_at: "2016-12-15", end_at: "2016-12-22" }.to_json
    end

    context "rentals ids given" do
      let(:rental_ids) {
        find_resources("#{@casette_base_path}_rentals/returns_rentals.yml", "rentals").map { |r| r["id"] }[0..1]
      }

      it "makes a search within given rentals" do
        rentals = client.rentals_search(ids: rental_ids, start_at: "2016-12-15", end_at: "2016-12-22")
        expect(rentals.size).to eq(1)
        assert_requested :post, bs_url("rentals/#{rental_ids.join(',')}/search"),
          body: { start_at: "2016-12-15", end_at: "2016-12-22" }.to_json
      end
    end

    it "performs autopagination using POST" do
      rentals = client.rentals_search(per_page: 1, auto_paginate: true)
      expect(rentals.size).to eq(4)
      assert_requested :post, bs_url("rentals/search"), body: { per_page: 1 }.to_json
      assert_requested :post, bs_url("rentals/search?page=2&per_page=1")
      assert_requested :post, bs_url("rentals/search?page=3&per_page=1")
      assert_requested :post, bs_url("rentals/search?page=4&per_page=1")
    end
  end

  describe ".rental", :vcr do
    let(:prefetched_rental) {
      find_resource("#{@casette_base_path}_rentals/returns_rentals.yml", "rentals")
    }

    it "returns a single rental" do
      rental = client.rental(prefetched_rental[:id])
      expect(rental.name).to eq(prefetched_rental[:name])
      expect(rental).to_not have_key(:availability)
    end

    context "with additional query params" do
      it "returns a single rental with defined params" do
        rental = client.rental(prefetched_rental[:id], include: [:availability, :change_over])
        expect(rental.name).to eq(prefetched_rental[:name])
        expect(rental).to have_key(:availability)
        expect(rental).to have_key(:change_over)
      end
    end
  end

  describe ".create_rental", :vcr do
    let(:attributes) { { name: "New rental", sleeps: 2 } }

    it "creates a new rental" do
      client.create_rental(attributes)
      assert_requested :post, bs_url("rentals"),
        body: { rentals: [attributes] }.to_json
    end

    it "returns newly created rental" do
      VCR.use_cassette("BookingSync_API_Client_Rentals/_create_rental/creates_a_new_rental") do
        rental = client.create_rental(attributes)
        expect(rental.name).to eq("New rental")
        expect(rental.sleeps).to eq(2)
      end
    end
  end

  describe ".edit_rental", :vcr do
    let(:created_rental_id) {
      find_resource("#{casette_dir}/BookingSync_API_Client_Rentals/_create_rental/creates_a_new_rental.yml", "rentals")[:id]
    }

    it "updates given rental by ID" do
      client.edit_rental(created_rental_id, name: "Updated Rental name")
      assert_requested :put, bs_url("rentals/#{created_rental_id}"),
        body: { rentals: [{ name: "Updated Rental name" }] }.to_json
    end

    it "returns updated rental" do
      VCR.use_cassette("BookingSync_API_Client_Rentals/_edit_rental/updates_given_rental_by_ID") do
        rental = client.edit_rental(created_rental_id, name: "Updated Rental name")
        expect(rental).to be_kind_of(BookingSync::API::Resource)
        expect(rental.name).to eq("Updated Rental name")
      end
    end
  end

  describe ".delete_rental", :vcr do
    let(:created_rental_id) {
      find_resource("#{casette_dir}/BookingSync_API_Client_Rentals/_create_rental/creates_a_new_rental.yml", "rentals")[:id]
    }

    it "deletes given rental" do
      client.delete_rental(created_rental_id)
      assert_requested :delete, bs_url("rentals/#{created_rental_id}")
    end
  end

  describe ".rentals_meta", :vcr do
    let(:rental_ids) {
      find_resources("#{@casette_base_path}_rentals/returns_rentals.yml", "rentals").map { |r| r["id"] }
    }

    it "returns meta information about requested rentals" do
      client.rentals_meta(rental_ids)
      assert_requested :get, bs_url("rentals/#{rental_ids.join(',')}/meta")
    end

    it "returns meta information about all rentals" do
      client.rentals_meta
      assert_requested :get, bs_url("rentals/meta")
    end
  end
end
