module BookingSync::API
  # Class for rescuing all BS API errors
  class Error < StandardError
    attr_reader :status, :headers, :body

    def initialize(response)
      @status  = response.status
      @headers = response.headers
      @body    = response.body
    end

    def message(message = self.class)
      %{#{message}
HTTP status code : #{status}
Headers          : #{headers}
Body             : #{body}}
    end
  end

  class Unauthorized < Error; end
  class Forbidden < Error; end
  class UnprocessableEntity < Error; end
  class NotFound < Error; end
  class RateLimitExceeded < Error; end
  class UnsupportedResponse < Error
    def message
      super("Received unsupported response from BookingSync API")
    end
  end
end
