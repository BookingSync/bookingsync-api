require "spec_helper"

describe BookingSync::API::Client::Seasons do

  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".seasons", :vcr do
    it "returns seasons" do
      expect(client.seasons).not_to be_empty
      assert_requested :get, bs_url("seasons")
    end
  end

  describe ".create_season", :vcr do
    let(:attributes) {{
      name: "New season",
      ratio: 0.2,
      minimum_stay: 4
    }}
    let(:rates_table) { BookingSync::API::Resource.new(client, id: 13) }

    it "creates a new season" do
      client.create_season(rates_table, attributes)
      assert_requested :post, bs_url("rates_tables/13/seasons"),
        body: {seasons: [attributes]}.to_json
    end

    it "returns newly created season" do
      VCR.use_cassette('BookingSync_API_Client_Seasons/_create_season/creates_a_new_season') do
        season = client.create_season(rates_table, attributes)
        expect(season.name).to eql(attributes[:name])
        expect(season.minimum_stay).to eql(attributes[:minimum_stay])
      end
    end
  end

  describe ".edit_season", :vcr do
    let(:attributes) {
      { name: "Updated season" }
    }
    it "updates given season by ID" do
      client.edit_season(6, attributes)
      assert_requested :put, bs_url("seasons/6"),
        body: { seasons: [attributes] }.to_json
    end

    it "returns updated season" do
      VCR.use_cassette('BookingSync_API_Client_Seasons/_edit_season/updates_given_season_by_ID') do
        season = client.edit_season(6, attributes)
        expect(season).to be_kind_of(BookingSync::API::Resource)
        expect(season.name).to eq(attributes[:name])
      end
    end
  end

  describe ".delete_season", :vcr do
    it "deletes given season" do
      client.delete_season(10)
      assert_requested :delete, bs_url("seasons/10")
    end
  end
end
