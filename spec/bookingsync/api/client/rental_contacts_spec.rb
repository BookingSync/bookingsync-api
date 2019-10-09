require "spec_helper"

describe BookingSync::API::Client::RentalContacts do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".rental_contacts", :vcr do
    it "returns rental contacts" do
      expect(client.rental_contacts).not_to be_empty
      assert_requested :get, bs_url("rental_contacts")
    end

    describe "links" do
      it "returns associated rental" do
        rental_contacts = client.rental_contacts.first
        expect(rental_contacts.rental).not_to be_empty
      end

      it "returns associated contacts" do
        rental_contacts = client.rental_contacts.first
        expect(rental_contacts.dig(:links, :contact)).to eq 1
        expect(rental_contacts.dig(:links, :rental)).to eq 1
      end
    end
  end

  describe ".create_rental_contact", :vcr do
    let(:attributes) { { contact_id: 1, kind: "owner", roles: ["invoices"] } }
    let(:rental) { BookingSync::API::Resource.new(client, id: 1) }

    it "creates a new rental_contact" do
      client.create_rental_contact(rental, attributes)
      assert_requested :post, bs_url("rentals/#{rental}/rental_contacts"),
        body: { rental_contacts: [attributes] }.to_json
    end

    it "returns newly created rental_contact" do
      VCR.use_cassette("BookingSync_API_Client_RentalContacts/_create_rental_contact/creates_a_new_rental_contact") do
        rental_contacts = client.create_rental_contact(rental, attributes)
        expect(rental_contacts.dig(:links, :contact)).to eq(1)
        expect(rental_contacts.dig(:links, :rental)).to eq(1)
      end
    end
  end

  describe ".edit_rental_contact", :vcr do
    let(:attributes) { { kind: "manager" } }
    let(:created_rental_contacts_id) {
      find_resource("#{@casette_base_path}_create_rental_contact/creates_a_new_rental_contact.yml", "rental_contacts")[:id]
    }

    it "updates given rental_contact by ID" do
      client.edit_rental_contact(created_rental_contacts_id, attributes)
      assert_requested :put, bs_url("rental_contacts/#{created_rental_contacts_id}"),
        body: { rental_contacts: [attributes] }.to_json
    end

    it "returns updated rental_contact" do
      VCR.use_cassette("BookingSync_API_Client_RentalContacts/_edit_rental_contact/updates_given_rental_contact_by_ID") do
        rental_contacts = client.edit_rental_contact(created_rental_contacts_id, attributes)
        expect(rental_contacts).to be_kind_of(BookingSync::API::Resource)
        expect(rental_contacts.fetch(:kind)).to eq("manager")
      end
    end
  end

  describe ".delete_rental_contact", :vcr do
    let(:created_rental_contacts_id) {
      find_resource("#{@casette_base_path}_create_rental_contact/creates_a_new_rental_contact.yml", "rental_contacts")[:id]
    }

    it "deletes given rental_contact" do
      client.delete_rental_contact(created_rental_contacts_id)
      assert_requested :delete, bs_url("rental_contacts/#{created_rental_contacts_id}")
    end
  end
end
