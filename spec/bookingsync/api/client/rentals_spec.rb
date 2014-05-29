require "spec_helper"

describe BookingSync::API::Client::Rentals do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".rentals", :vcr do
    it "returns rentals" do
      expect(client.rentals).not_to be_empty
      assert_requested :get, bs_url("rentals")
    end

    it "returns rentals by ids" do
      rentals = client.rentals(ids: [26, 28])
      expect(rentals.size).to eql(2)
      assert_requested :get, bs_url("rentals/26,28")
    end

    describe "links" do
      it "returns associated photos" do
        rental = client.rentals.first
        expect(rental.photos).not_to be_empty
      end
    end
  end

  describe ".rental", :vcr do
    it "returns a single rental" do
      rental = client.rental(2)
      expect(rental.name).to eql("0 est")
    end
  end

  describe ".create_rental", :vcr do
    let(:attributes) { {
      name: "New rental",
      sleeps: 2
    } }

    it "creates a new rental" do
      client.create_rental(attributes)
      assert_requested :post, bs_url("rentals"),
        body: { rentals: [attributes] }.to_json
    end

    it "returns newly created rental" do
      VCR.use_cassette('BookingSync_API_Client_Rentals/_create_rental/creates_a_new_rental') do
        rental = client.create_rental(attributes)
        expect(rental.name).to eql("New rental")
        expect(rental.sleeps).to eql(2)
      end
    end
  end

  describe ".edit_rental", :vcr do
    it "updates given rental by ID" do
      client.edit_rental(2, name: 'Updated Rental name')
      assert_requested :put, bs_url("rentals/2"),
        body: { rentals: [{ name: 'Updated Rental name' }] }.to_json
    end

    it "returns updated rental" do
      VCR.use_cassette('BookingSync_API_Client_Rentals/_edit_rental/updates_given_rental_by_ID') do
        rental = client.edit_rental(2, name: 'Updated Rental name')
        expect(rental).to be_kind_of(BookingSync::API::Resource)
        expect(rental.name).to eq('Updated Rental name')
      end
    end
  end

  describe ".delete_rental", :vcr do
    it "deletes given rental" do
      client.delete_rental(4)
      assert_requested :delete, bs_url("rentals/4")
    end
  end

  describe ".rentals_meta", :vcr do
    it "returns meta information about requested rentals" do
      client.rentals_meta([67, 68])
      assert_requested :get, bs_url("rentals/67,68/meta")
    end

    it "returns meta information about all rentals" do
      client.rentals_meta
      assert_requested :get, bs_url("rentals/meta")
    end
  end
end
