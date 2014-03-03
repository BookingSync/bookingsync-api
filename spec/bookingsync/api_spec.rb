require "spec_helper"

describe BookingSync::API do
  it "should have a version number" do
    expect(BookingSync::API::VERSION).not_to be_nil
  end

  describe ".new" do
    it "returns a new Client" do
      client = BookingSync::API.new("token")
      expect(client).to be_kind_of(BookingSync::API::Client)
    end
  end
end
