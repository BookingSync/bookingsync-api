module BookingSync::API
  # Class for rescuing all BS API errors
  class Error < StandardError; end
  class Unauthorized < Error; end
  class UnprocessableEntity < Error; end
  class NotFound < Error; end

  class UnsupportedResponse < Error
    attr_reader :status, :headers, :body

    def initialize(response)
      @status  = response.status
      @headers = response.headers
      @body    = response.body
    end

    def message
      %Q{Received unsupported response from BookingSync API
HTTP status code : #{status}
Headers          : #{headers}
Body             : #{body}}
    end
  end
end
