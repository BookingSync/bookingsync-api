require "spec_helper"

describe BookingSync::API::Client::RentalAgreements do
  let(:client) { BookingSync::API::Client.new(test_access_token) }
  let(:attributes) {
    { body: "Lorem ipsum" }
  }

  describe ".rental_agreements", :vcr do
    it "returns rental agreements" do
      expect(client.rental_agreements).not_to be_empty
      assert_requested :get, bs_url("rental_agreements")
    end
  end

  describe ".rental_agreement", :vcr do
    it "returns a single rental_agreement" do
      rental_agreement = client.rental_agreement(6905)
      expect(rental_agreement.id).to eq 6905
    end
  end

  describe ".create_rental_agreement", :vcr do
    it "creates a new rental agreement" do
      client.create_rental_agreement(attributes)
      assert_requested :post, bs_url("rental_agreements"),
        body: { rental_agreements: [attributes] }.to_json
    end

    it "returns newly created rental agreement" do
      VCR.use_cassette('BookingSync_API_Client_RentalAgreements/_create_rental_agreement/creates_a_new_rental_agreement') do
        rental_agreement = client.create_rental_agreement(attributes)
        expect(rental_agreement.body).to eql(attributes[:body])
      end
    end
  end

  describe ".create_rental_agreement_for_booking", :vcr do
    let(:booking) { BookingSync::API::Resource.new(client, id: 2) }

    it "creates a new rental agreement" do
      client.create_rental_agreement_for_booking(booking, attributes)
      assert_requested :post, bs_url("bookings/#{booking}/rental_agreements"),
        body: {rental_agreements: [attributes]}.to_json
    end

    it "returns newly created rental agreement" do
      VCR.use_cassette('BookingSync_API_Client_RentalAgreements/_create_rental_agreement_for_booking/creates_a_new_rental_agreement') do
        rental_agreement = client.create_rental_agreement_for_booking(booking, attributes)
        expect(rental_agreement.body).to eql(attributes[:body])
      end
    end
  end

  describe ".create_rental_agreement_for_rental", :vcr do
    let(:rental) { BookingSync::API::Resource.new(client, id: 20) }

    it "creates a new rental agreement" do
      client.create_rental_agreement_for_rental(rental, attributes)
      assert_requested :post, bs_url("rentals/20/rental_agreements"),
        body: {rental_agreements: [attributes]}.to_json
    end

    it "returns newly created rental agreement" do
      VCR.use_cassette('BookingSync_API_Client_RentalAgreements/_create_rental_agreement_for_rental/creates_a_new_rental_agreement') do
        rental_agreement = client.create_rental_agreement_for_rental(rental, attributes)
        expect(rental_agreement.body).to eql(attributes[:body])
      end
    end
  end
end
