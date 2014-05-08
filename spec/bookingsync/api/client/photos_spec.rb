require "spec_helper"

describe BookingSync::API::Client::Photos do
  let(:client) { BookingSync::API::Client.new(test_access_token) }
  let(:rental) { BookingSync::API::Resource.new(client, id: 2) }

  describe ".photos", :vcr do
    it "returns photos" do
      expect(client.photos).not_to be_empty
      assert_requested :get, bs_url("photos")
    end
  end

  describe ".create_photo", :vcr do
    let(:attributes) do
      {file_path: "spec/fixtures/files/test.jpg",
        description_en: "Funny", kind: "livingroom"}
    end

    it "creates a photo" do
      client.create_photo(rental, attributes)
      assert_requested :post, bs_url("rentals/2/photos"),
        body: {photos: [attributes]}.to_json
    end

    it "returns newly created photo" do
      VCR.use_cassette('BookingSync_API_Client_Photos/_create_photo/creates_a_photo') do
        photo = client.create_photo(rental, attributes)
        expect(photo.kind).to eq("livingroom")
        expect(photo.description.en).to eq("Funny")
      end
    end
  end

  describe ".edit_photo", :vcr do
    it "updates photo's description" do
      photo = client.edit_photo(23, description_en: "Not funny anymore")
      expect(photo.description.en).to eq("Not funny anymore")
    end

    it "updates photo's image file" do
      photo = client.edit_photo(23, file_path: "spec/fixtures/files/test.jpg")
      expect(photo.description.en).to eq("Not funny anymore")
    end
  end

  describe ".delete_photo", :vcr do
    it "delete given photo" do
      expect(client.delete_photo(23)).to be_nil
    end
  end
end
