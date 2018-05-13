
require "spec_helper"

describe BookingSync::API::Client::Attachments do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".attachments", :vcr do
    it "returns attachments" do
      expect(client.attachments).not_to be_empty
      assert_requested :get, bs_url("inbox/attachments")
    end
  end

  describe ".create_attachment", :vcr do
    let(:attributes) do
      {
        file_path: "spec/fixtures/files/test.jpg",
        name: "test.jpg",
      }
    end

    it "creates a attachment with file path" do
      client.create_attachment(attributes)
      assert_requested :post, bs_url("inbox/attachments"),
        body: { attachments: [attributes] }.to_json
    end

    it "creates a new attachment with encoded file" do
      encoded = Base64.encode64(File.read("spec/fixtures/files/test.jpg"))
      client.create_attachment(file: encoded, name: "test.jpg")
      assert_requested :post, bs_url("inbox/attachments"),
        body: { attachments: [file: encoded, name: "test.jpg"] }.to_json
    end

    it "creates a attachment with remote URL" do
      remote_url = "https://www.ruby-lang.org/images/header-ruby-logo.png"
      client.create_attachment(remote_file_url: remote_url, name: "test.jpg")
      assert_requested :post, bs_url("inbox/attachments"),
        body: { attachments: [remote_file_url: remote_url, name: "test.jpg"] }.to_json
    end

    it "returns newly created attachment" do
      VCR.use_cassette("BookingSync_API_Client_Attachments/_create_attachment/creates_a_new_attachment") do
        attachment = client.create_attachment(attributes)
        expect(attachment.name).to eq ("test.jpg")
      end
    end
  end

  describe ".edit_attachment", :vcr do
    let(:attributes) { { name: "updated_test.jpg" } }
    let(:created_attachment_id) {
      find_resource("#{@casette_base_path}_create_attachment/creates_a_new_attachment.yml", "attachments")[:id]
    }

    it "updates given attachment by ID" do
      client.edit_attachment(created_attachment_id, attributes)
      assert_requested :put, bs_url("inbox/attachments/#{created_attachment_id}"),
        body: { attachments: [attributes] }.to_json
    end

    it "returns updated attachment" do
      VCR.use_cassette("BookingSync_API_Client_Attachments/_edit_attachment/updates_given_attachment_by_ID") do
        attachment = client.edit_attachment(created_attachment_id, attributes)
        expect(attachment).to be_kind_of(BookingSync::API::Resource)
        expect(attachment.name).to eq("updated_test.jpg")
      end
    end
  end
end
