require "spec_helper"

describe BookingSync::API::Client::Photos do
  let(:client) { BookingSync::API::Client.new(test_access_token) }
  let(:rental) { BookingSync::API::Resource.new(client, id: 5116) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".photos", :vcr do
    it "returns photos" do
      expect(client.photos).not_to be_empty
      assert_requested :get, bs_url("photos")
    end
  end

  describe ".photo", :vcr do
    let(:prefetched_photo_id) {
      find_resource("#{@casette_base_path}_photos/returns_photos.yml", "photos")[:id]
    }

    it "returns a single photo" do
      photo = client.photo(prefetched_photo_id)
      expect(photo.id).to eq prefetched_photo_id
    end
  end

  describe ".create_photo", :vcr do
    let(:attributes) do
      { photo_path: "spec/fixtures/files/test.jpg",
        description_en: "Funny", kind: "livingroom" }
    end

    it "creates a photo with photo path" do
      photo = client.create_photo(rental, attributes)
      assert_requested :post, bs_url("rentals/#{rental}/photos"),
        body: { photos: [attributes] }.to_json
      expect(photo.kind).to eq("livingroom")
    end

    it "creates a photo with encoded photo file" do
      encoded = Base64.encode64(File.read("spec/fixtures/files/test.jpg"))
      photo = client.create_photo(rental, photo: encoded, kind: "livingroom")
      assert_requested :post, bs_url("rentals/#{rental}/photos"),
        body: { photos: [photo: encoded, kind: "livingroom"] }.to_json
      expect(photo.kind).to eq("livingroom")
    end

    it "creates a photo with remote URL" do
      remote_url = "https://www.ruby-lang.org/images/header-ruby-logo.png"
      photo = client.create_photo(rental, remote_photo_url: remote_url,
        kind: "livingroom")
      assert_requested :post, bs_url("rentals/#{rental}/photos"),
        body: { photos: [remote_photo_url: remote_url, kind: "livingroom"] }.to_json
      expect(photo.kind).to eq("livingroom")
    end

    it "returns newly created photo" do
      VCR.use_cassette("BookingSync_API_Client_Photos/_create_photo/creates_a_photo") do
        photo = client.create_photo(rental, attributes)
        expect(photo.kind).to eq("livingroom")
        expect(photo.description.en).to eq("Funny")
      end
    end
  end

  describe ".edit_photo", :vcr do
    let(:created_photo_id) {
      find_resource("#{@casette_base_path}_create_photo/creates_a_photo_with_photo_path.yml", "photos")[:id]
    }

    it "updates photo's description" do
      photo = client.edit_photo(created_photo_id, description_en: "Not funny anymore")
      expect(photo.description.en).to eq("Not funny anymore")
    end

    it "updates photo's image file" do
      photo = client.edit_photo(created_photo_id, file_path: "spec/fixtures/files/test.jpg")
      expect(photo.description.en).to eq("Not funny anymore")
    end
  end

  describe ".delete_photo", :vcr do
    let(:created_photo_id) {
      find_resource("#{@casette_base_path}_create_photo/creates_a_photo_with_photo_path.yml", "photos")[:id]
    }

    it "delete given photo" do
      expect(client.delete_photo(created_photo_id)).to be_nil
    end
  end
end
