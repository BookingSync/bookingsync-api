require "spec_helper"

describe BookingSync::API::Client::Contacts do
  let(:api) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".contacts", :vcr do
    it "returns contacts" do
      expect(api.contacts).not_to be_empty
      assert_requested :get, bs_url("contacts")
    end

    it "returns contacts by ids" do
      contact_ids = find_resources("#{@casette_base_path}_contacts/returns_contacts.yml", "contacts").map { |r| r["id"] }[0..1]
      contacts = api.contacts(ids: contact_ids)
      expect(contacts.size).to eq(1)
      assert_requested :get, bs_url("contacts/#{contact_ids.join(',')}")
    end
  end

  describe ".contact", :vcr do
    it "returns contact" do
      expect(api.contact(1)).not_to be_empty
      assert_requested :get, bs_url("contacts/1")
    end
  end

  describe ".contact", :vcr do
    let(:prefetched_contact_id) {
      find_resource("#{@casette_base_path}_contacts/returns_contacts.yml", "contacts")[:id]
    }

    it "returns a single contact" do
      contact = api.contact(prefetched_contact_id)
      expect(contact.id).to eq prefetched_contact_id
    end
  end

  describe ".create_contact", :vcr do
    let(:attributes) do
      {
        firstname: "John",
        lastname: "Doe",
        email: "halldor@example.com",
        website: "http://www.demo.com",
        address1: "Demo address",
        gender: "male",
        phones: [{ label: "default", number: "123456789" }],
        country_code: "IS",
        city: "Reykjavik",
        zip: "33209",
        state: "Demo",
        spoken_languages: [:en]
      }
    end

    it "creates a new contact" do
      api.create_contact(attributes)
      assert_requested :post, bs_url("contacts"),
        body: { contacts: [attributes] }.to_json
    end

    it "returns newly created contact" do
      VCR.use_cassette("BookingSync_API_Client_Contacts/_create_contact/creates_a_new_contact") do
        contact = api.create_contact(attributes)
        expect(contact.email).to eq "halldor@example.com"
        expect(contact.fullname).to eq ("John Doe")
      end
    end
  end

  describe ".edit_contact", :vcr do
    let(:created_contact_id) {
      find_resource("#{@casette_base_path}_create_contact/creates_a_new_contact.yml", "contacts")[:id]
    }

    it "updates given contact by ID" do
      api.edit_contact(created_contact_id, firstname: "Knut", lastname: "Eljassen")
      assert_requested :put, bs_url("contacts/#{created_contact_id}"),
        body: { contacts: [{ firstname: "Knut", lastname: "Eljassen" }] }.to_json
    end

    it "returns updated contact" do
      VCR.use_cassette("BookingSync_API_Client_Contacts/_edit_contact/updates_given_contact_by_ID") do
        contact = api.edit_contact(created_contact_id, fullname: "Knut Eljassen")
        expect(contact).to be_kind_of(BookingSync::API::Resource)
        expect(contact.fullname).to eq("Knut Eljassen")
      end
    end
  end
end
