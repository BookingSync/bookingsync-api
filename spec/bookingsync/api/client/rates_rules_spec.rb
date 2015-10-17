require "spec_helper"

describe BookingSync::API::Client::RatesRules do

  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".rates_rules", :vcr do
    it "returns rates rules" do
      expect(client.rates_rules).not_to be_empty
      assert_requested :get, bs_url("rates_rules")
    end
  end

  describe ".rates_rule", :vcr do
    it "returns a single rates_rule" do
      rates_rule = client.rates_rule(252)
      expect(rates_rule.id).to eq 252
    end
  end

  describe ".create_rates_rule", :vcr do
    let(:attributes) do
      {
        start_date: "2013-04-10",
        end_date: "2013-04-22",
        kind: "stay_at_least",
        percentage: 10,
        variables: { length: 1, unit: "days" }
      }
    end
    let(:rates_table) { BookingSync::API::Resource.new(client, id: 274) }

    it "creates a new rates_rule" do
      client.create_rates_rule(rates_table, attributes)
      assert_requested :post, bs_url("rates_tables/274/rates_rules"),
        body: { rates_rules: [attributes] }.to_json
    end

    it "returns newly created rates_rule" do
      VCR.use_cassette('BookingSync_API_Client_RatesRules/_create_rates_rule/creates_a_new_rates_rule') do
        rates_rule = client.create_rates_rule(rates_table, attributes)
        expect(rates_rule.start_date).to eql(Time.parse(attributes[:start_date]))
        expect(rates_rule.end_date).to eql(Time.parse(attributes[:end_date]))
      end
    end
  end

  describe ".edit_rates_rule", :vcr do
    let(:attributes) { { end_date: '2014-07-15' } }

    it "updates given rates_rule by ID" do
      client.edit_rates_rule(252, attributes)
      assert_requested :put, bs_url("rates_rules/252"),
        body: { rates_rules: [attributes] }.to_json
    end

    it "returns updated rates_rule" do
      VCR.use_cassette('BookingSync_API_Client_RatesRules/_edit_rates_rule/updates_given_rates_rule_by_ID') do
        rates_rule = client.edit_rates_rule(252, attributes)
        expect(rates_rule).to be_kind_of(BookingSync::API::Resource)
        expect(rates_rule.end_date).to eq(Time.parse(attributes[:end_date]))
      end
    end
  end

  describe ".delete_rates_rule", :vcr do
    it "deletes given rates_rule" do
      client.delete_rates_rule(250)
      assert_requested :delete, bs_url("rates_rules/250")
    end
  end
end
