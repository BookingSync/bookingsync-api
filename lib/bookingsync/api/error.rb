module BookingSync::API
  class Error < StandardError; end

  class RequestError < Error
    attr_reader :method, :url, :data, :exception

    def initialize(method, url, data, exception)
      @method    = method
      @url       = url
      @data      = data
      @exception = exception
    end

    def message(message = self.class)
      %Q{#{message}
METHOD    : #{method}
URL       : #{url}
Body      : #{data}
Exception : #{exception}
}
    end
  end

  # Represents BookingSync API error responses
  class ResponseError < Error
    attr_reader :status, :headers, :body

    def initialize(response)
      @status  = response.status
      @headers = response.headers
      @body    = response.body
    end

    def message(message = self.class)
      %Q{#{message}
HTTP status code : #{status}
Headers          : #{headers}
Body             : #{body}}
    end
  end

  class Unauthorized < ResponseError; end
  class Forbidden < ResponseError; end
  class UnprocessableEntity < ResponseError; end
  class NotFound < ResponseError; end
  class UnsupportedResponse < ResponseError
    def message
      super("Received unsupported response from BookingSync API")
    end
  end
end
