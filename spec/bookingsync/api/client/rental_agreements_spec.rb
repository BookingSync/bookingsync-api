require "spec_helper"

describe BookingSync::API::Client::RentalAgreements do
  let(:client) { BookingSync::API::Client.new(test_access_token) }
  let(:attributes) {
    { body: "Lorem ipsum" }
  }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".rental_agreements", :vcr do
    it "returns rental agreements" do
      expect(client.rental_agreements).not_to be_empty
      assert_requested :get, bs_url("rental_agreements")
    end
  end

  describe ".rental_agreement", :vcr do
    let(:prefetched_rental_agreement_id) {
      find_resource("#{@casette_base_path}_rental_agreements/returns_rental_agreements.yml", "rental_agreements")[:id]
    }

    it "returns a single rental_agreement" do
      rental_agreement = client.rental_agreement(prefetched_rental_agreement_id)
      expect(rental_agreement.id).to eq prefetched_rental_agreement_id
    end
  end

  describe ".create_rental_agreement", :vcr do
    it "creates a new rental agreement" do
      client.create_rental_agreement(attributes)
      assert_requested :post, bs_url("rental_agreements"),
        body: { rental_agreements: [attributes] }.to_json
    end

    it "returns newly created rental agreement" do
      VCR.use_cassette("BookingSync_API_Client_RentalAgreements/_create_rental_agreement/creates_a_new_rental_agreement") do
        rental_agreement = client.create_rental_agreement(attributes)
        expect(rental_agreement.body).to eql(attributes[:body])
      end
    end
  end

  describe ".create_rental_agreement_for_booking", :vcr do
    let(:booking) do
      find_resource("#{casette_dir}/BookingSync_API_Client_Bookings/_booking/returns_a_single_booking.yml", "bookings")
    end

    it "creates a new rental agreement" do
      client.create_rental_agreement_for_booking(booking, attributes)
      assert_requested :post, bs_url("bookings/#{booking}/rental_agreements"),
        body: { rental_agreements: [attributes] }.to_json
    end

    it "returns newly created rental agreement" do
      VCR.use_cassette("BookingSync_API_Client_RentalAgreements/_create_rental_agreement_for_booking/creates_a_new_rental_agreement") do
        rental_agreement = client.create_rental_agreement_for_booking(booking, attributes)
        expect(rental_agreement.body).to eql(attributes[:body])
      end
    end
  end

  describe ".create_rental_agreement_for_rental", :vcr do
    let(:rental) do
      find_resource("#{casette_dir}/BookingSync_API_Client_Rentals/_rental/returns_a_single_rental.yml", "rentals")
    end

    it "creates a new rental agreement" do
      client.create_rental_agreement_for_rental(rental, attributes)
      assert_requested :post, bs_url("rentals/#{rental}/rental_agreements"),
        body: { rental_agreements: [attributes] }.to_json
    end

    it "returns newly created rental agreement" do
      VCR.use_cassette("BookingSync_API_Client_RentalAgreements/_create_rental_agreement_for_rental/creates_a_new_rental_agreement") do
        rental_agreement = client.create_rental_agreement_for_rental(rental, attributes)
        expect(rental_agreement.body).to eql(attributes[:body])
      end
    end
  end
end
