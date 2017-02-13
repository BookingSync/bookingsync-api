require "spec_helper"

describe BookingSync::API::Client::Seasons do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".seasons", :vcr do
    it "returns seasons" do
      expect(client.seasons).not_to be_empty
      assert_requested :get, bs_url("seasons")
    end
  end

  describe ".season", :vcr do
    let(:prefetched_season_id) {
      find_resource("#{@casette_base_path}_seasons/returns_seasons.yml", "seasons")[:id]
    }

    it "returns a single season" do
      season = client.season(prefetched_season_id)
      expect(season.id).to eq prefetched_season_id
    end
  end

  describe ".create_season", :vcr do
    let(:attributes) { { name: "New season", ratio_percentage: 0.2, minimum_stay: 4 } }
    let(:rates_table) do
      find_resource("#{casette_dir}/BookingSync_API_Client_RatesTables/_rates_tables/returns_rates_tables.yml", "rates_tables")
    end

    it "creates a new season" do
      client.create_season(rates_table, attributes)
      assert_requested :post, bs_url("rates_tables/#{rates_table}/seasons"),
        body: { seasons: [attributes] }.to_json
    end

    it "returns newly created season" do
      VCR.use_cassette("BookingSync_API_Client_Seasons/_create_season/creates_a_new_season") do
        season = client.create_season(rates_table, attributes)
        expect(season.name).to eql(en: attributes[:name])
        expect(season.minimum_stay).to eql(attributes[:minimum_stay])
      end
    end
  end

  describe ".edit_season", :vcr do
    let(:attributes) {
      { name: "Updated season name 2" }
    }
    let(:created_season_id) {
      find_resource("#{@casette_base_path}_create_season/creates_a_new_season.yml", "seasons")[:id]
    }

    it "updates given season by ID" do
      client.edit_season(created_season_id, attributes)
      assert_requested :put, bs_url("seasons/#{created_season_id}"),
        body: { seasons: [attributes] }.to_json
    end

    it "returns updated season" do
      VCR.use_cassette("BookingSync_API_Client_Seasons/_edit_season/updates_given_season_by_ID") do
        season = client.edit_season(created_season_id, attributes)
        expect(season).to be_kind_of(BookingSync::API::Resource)
        expect(season.name).to eq(en: attributes[:name])
      end
    end
  end

  describe ".delete_season", :vcr do
    let(:created_season_id) {
      find_resource("#{@casette_base_path}_create_season/creates_a_new_season.yml", "seasons")[:id]
    }

    it "deletes given season" do
      client.delete_season(created_season_id)
      assert_requested :delete, bs_url("seasons/#{created_season_id}")
    end
  end
end
