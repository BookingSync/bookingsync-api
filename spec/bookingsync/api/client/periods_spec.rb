require "spec_helper"

describe BookingSync::API::Client::Periods do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".periods", :vcr do
    it "returns periods" do
      expect(client.periods).not_to be_empty
      assert_requested :get, bs_url("periods")
    end
  end

  describe ".period", :vcr do
    let(:prefetched_period_id) {
      find_resource("#{@casette_base_path}_periods/returns_periods.yml", "periods")[:id]
    }

    it "returns a single period" do
      period = client.period(prefetched_period_id)
      expect(period.id).to eq prefetched_period_id
    end
  end

  describe ".create_period", :vcr do
    let(:attributes) { { start_date: "2017-04-10", end_date: "2017-04-22" } }
    let(:season) {
      find_resource("#{casette_dir}/BookingSync_API_Client_Seasons/_seasons/returns_seasons.yml", "seasons")
    }

    it "creates a new period" do
      client.create_period(season, attributes)
      assert_requested :post, bs_url("seasons/#{season}/periods"),
        body: { periods: [attributes] }.to_json
    end

    it "returns newly created period" do
      VCR.use_cassette("BookingSync_API_Client_Periods/_create_period/creates_a_new_period") do
        period = client.create_period(season, attributes)
        expect(period.start_date).to eq(Time.parse(attributes[:start_date]))
        expect(period.end_date).to eq(Time.parse(attributes[:end_date]))
      end
    end
  end

  describe ".edit_period", :vcr do
    let(:attributes) { { end_date: "2017-07-15" } }
    let(:created_period_id) {
      find_resource("#{@casette_base_path}_create_period/creates_a_new_period.yml", "periods")[:id]
    }

    it "updates given period by ID" do
      client.edit_period(created_period_id, attributes)
      assert_requested :put, bs_url("periods/#{created_period_id}"),
        body: { periods: [attributes] }.to_json
    end

    it "returns updated period" do
      VCR.use_cassette("BookingSync_API_Client_Periods/_edit_period/updates_given_period_by_ID") do
        period = client.edit_period(created_period_id, attributes)
        expect(period).to be_kind_of(BookingSync::API::Resource)
        expect(period.end_date).to eq(Time.parse(attributes[:end_date]))
      end
    end
  end

  describe ".delete_period", :vcr do
    let(:created_period_id) {
      find_resource("#{@casette_base_path}_create_period/creates_a_new_period.yml", "periods")[:id]
    }

    it "deletes given period" do
      client.delete_period(created_period_id)
      assert_requested :delete, bs_url("periods/#{created_period_id}")
    end
  end
end
