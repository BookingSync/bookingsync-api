require "spec_helper"

describe BookingSync::API::Client::RatesTables do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".rates_tables", :vcr do
    it "returns rates tables" do
      expect(client.rates_tables).not_to be_empty
      assert_requested :get, bs_url("rates_tables")
    end
  end

  describe ".rates_table", :vcr do
    let(:prefetched_rates_table_id) {
      find_resource("#{@casette_base_path}_rates_tables/returns_rates_tables.yml", "rates_tables")[:id]
    }

    it "returns a single rates_table" do
      rates_table = client.rates_table(prefetched_rates_table_id)
      expect(rates_table.id).to eq prefetched_rates_table_id
    end
  end

  describe ".create_rates_table", :vcr do
    let(:attributes) {
      { name: "New test rate table" }
    }

    it "creates a new rates_table" do
      client.create_rates_table(attributes)
      assert_requested :post, bs_url("rates_tables"),
        body: { rates_tables: [attributes] }.to_json
    end

    it "returns newly created rates_table" do
      VCR.use_cassette("BookingSync_API_Client_RatesTables/_create_rates_table/creates_a_new_rates_table") do
        rates_table = client.create_rates_table(attributes)
        expect(rates_table.name).to eql(attributes[:name])
      end
    end
  end

  describe ".edit_rates_table", :vcr do
    let(:attributes) {
      { name: "Updated rate table" }
    }
    let(:created_rates_table_id) {
      find_resource("#{@casette_base_path}_create_rates_table/creates_a_new_rates_table.yml", "rates_tables")[:id]
    }

    it "updates given rates_table by ID" do
      client.edit_rates_table(created_rates_table_id, attributes)
      assert_requested :put, bs_url("rates_tables/#{created_rates_table_id}"),
        body: { rates_tables: [attributes] }.to_json
    end

    it "returns updated rates_table" do
      VCR.use_cassette("BookingSync_API_Client_RatesTables/_edit_rates_table/updates_given_rates_table_by_ID") do
        rates_table = client.edit_rates_table(created_rates_table_id, attributes)
        expect(rates_table).to be_kind_of(BookingSync::API::Resource)
        expect(rates_table.name).to eql(attributes[:name])
      end
    end
  end

  describe ".delete_rates_table", :vcr do
    let(:created_rates_table_id) {
      find_resource("#{@casette_base_path}_create_rates_table/creates_a_new_rates_table.yml", "rates_tables")[:id]
    }

    it "deletes given rates_table" do
      client.delete_rates_table(created_rates_table_id)
      assert_requested :delete, bs_url("rates_tables/#{created_rates_table_id}")
    end
  end
end
