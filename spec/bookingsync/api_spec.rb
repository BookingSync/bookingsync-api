require 'spec_helper'

describe BookingSync::API do
  it 'should have a version number' do
    BookingSync::API::VERSION.should_not be_nil
  end
end
