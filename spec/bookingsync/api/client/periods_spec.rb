require "spec_helper"

describe BookingSync::API::Client::Periods do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  describe ".periods", :vcr do
    it "returns periods" do
      expect(client.periods).not_to be_empty
      assert_requested :get, bs_url("periods")
    end
  end

  describe ".create_period", :vcr do
    let(:attributes) { {start_at: "2013-04-10", end_at: "2013-04-22"} }
    let(:season) { BookingSync::API::Resource.new(client, id: 9) }

    it "creates a new period" do
      client.create_period(season, attributes)
      assert_requested :post, bs_url("seasons/9/periods"),
        body: {periods: [attributes]}.to_json
    end

    it "returns newly created period" do
      VCR.use_cassette('BookingSync_API_Client_Periods/_create_period/creates_a_new_period') do
        period = client.create_period(season, attributes)
        expect(period.start_at).to eql(Time.parse(attributes[:start_at]))
        expect(period.end_at).to eql(Time.parse(attributes[:end_at]))
      end
    end
  end

  describe ".edit_period", :vcr do
    let(:attributes) { {end_at: '2014-07-15'} }

    it "updates given period by ID" do
      client.edit_period(6, attributes)
      assert_requested :put, bs_url("periods/6"),
        body: { periods: [attributes] }.to_json
    end

    it "returns updated period" do
      VCR.use_cassette('BookingSync_API_Client_Periods/_edit_period/updates_given_period_by_ID') do
        period = client.edit_period(6, attributes)
        expect(period).to be_kind_of(BookingSync::API::Resource)
        expect(period.end_at).to eq(Time.parse(attributes[:end_at]))
      end
    end
  end

  describe ".delete_period", :vcr do
    it "deletes given period" do
      client.delete_period(3)
      assert_requested :delete, bs_url("periods/3")
    end
  end
end
