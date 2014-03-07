module BookingSync::API
  # Class for rescuing all BS API errors
  class Error < StandardError; end
  class Unauthorized < Error; end
end
