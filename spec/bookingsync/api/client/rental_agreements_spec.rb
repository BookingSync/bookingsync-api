require "spec_helper"

describe BookingSync::API::Client::RentalAgreements do
  let(:client) { BookingSync::API::Client.new(test_access_token) }
  let(:attributes) {
    { body: "Lorem ipsum" }
  }

  describe ".rental_agreements", :vcr do
    it "returns rental agreements" do
      expect(client.rental_agreements).not_to be_nil
      assert_requested :get, bs_url("rental_agreements")
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
    let(:booking_id) { 2 }

    it "creates a new rental agreement" do
      client.create_rental_agreement_for_booking(booking_id, attributes)
      assert_requested :post, bs_url("rental_agreements"),
        body: { booking_id: booking_id, rental_agreements: [attributes] }.to_json
    end

    it "returns newly created rental agreement" do
      VCR.use_cassette('BookingSync_API_Client_RentalAgreements/_create_rental_agreement_for_booking/creates_a_new_rental_agreement') do
        rental_agreement = client.create_rental_agreement_for_booking(booking_id, attributes)
        expect(rental_agreement.body).to eql(attributes[:body])
      end
    end
  end

  describe ".create_rental_agreement_for_rental", :vcr do
    let(:rental_id) { 20 }

    it "creates a new rental agreement" do
      client.create_rental_agreement_for_rental(rental_id, attributes)
      assert_requested :post, bs_url("rental_agreements"),
        body: { rental_id: rental_id, rental_agreements: [attributes] }.to_json
    end

    it "returns newly created rental agreement" do
      VCR.use_cassette('BookingSync_API_Client_RentalAgreements/_create_rental_agreement_for_rental/creates_a_new_rental_agreement') do
        rental_agreement = client.create_rental_agreement_for_rental(rental_id, attributes)
        expect(rental_agreement.body).to eql(attributes[:body])
      end
    end
  end
end
