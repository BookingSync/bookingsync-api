require "spec_helper"

describe BookingSync::API::Client::BookingsTags do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".bookings_tags", :vcr do
    it "returns bookings tags" do
      expect(client.bookings_tags).not_to be_empty
      assert_requested :get, bs_url("bookings_tags")
    end
  end

  describe ".bookings_tag", :vcr do
    let(:prefetched_bookings_tag_id) {
      find_resource("#{@casette_base_path}_bookings_tags/returns_bookings_tags.yml", "bookings_tags")[:id]
    }

    it "returns a single bookings_tag" do
      bookings_tag = client.bookings_tag(prefetched_bookings_tag_id)
      expect(bookings_tag.id).to eq prefetched_bookings_tag_id
    end
  end
end
