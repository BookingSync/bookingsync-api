require "spec_helper"

describe BookingSync::API::Client::Taxes do
  let(:client) { BookingSync::API::Client.new(test_access_token) }

  before { |ex| @casette_base_path = casette_path(casette_dir, ex.metadata) }

  describe ".taxes", :vcr do
    it "returns taxes" do
      expect(client.taxes).not_to be_empty
      assert_requested :get, bs_url("taxes")
    end
  end

  describe ".tax", :vcr do
    let(:prefetched_tax_id) {
      find_resource("#{@casette_base_path}_taxes/returns_taxes.yml", "taxes")[:id]
    }

    it "returns a single tax" do
      tax = client.tax(prefetched_tax_id)
      expect(tax.id).to eq prefetched_tax_id
    end
  end
end
