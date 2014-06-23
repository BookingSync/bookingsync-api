require 'forwardable'

module BookingSync::API::Middleware
  # Provides logger for request and responses made by API Client.
  # JSON data is displayed in an eye-friendly format.
  # User can provide his own logger in BookingSync::API::Client.new
  #
  # Log Levels
  #   INFO - logged are only request method and URL.
  #   DEBUG - logged are headers and bodies of requests and responses.
  class Logger < Faraday::Middleware
    extend Forwardable

    def initialize(app, logger)
      super(app)
      @logger = logger
    end

    def_delegators :@logger, :debug, :info, :warn, :error, :fatal

    def call(env)
      info "Request #{env.method.upcase} #{env.url.to_s}"
      debug('Request headers') { dump_headers env.request_headers }
      debug('Request body') { dump_body env.body }
      @app.call(env).tap do |response|
        info "Response X-Request-Id: #{env.response_headers['X-Request-Id']} #{env.method.upcase} #{env.url.to_s}"
        debug('Response headers') { dump_headers response.env.response_headers }
        debug('Response status') { response.env.status }
        debug('Response body') { dump_body response.env.body }
      end
    end

    private

    def dump_body(body)
      if body && body != ""
        JSON.pretty_generate(JSON.parse(body))
      else
        "No body"
      end
    rescue JSON::ParserError
      "Invalid JSON"
    end

    def dump_headers(headers)
      headers.map { |k, v| "#{k}: #{v.inspect}" }.join("\n")
    end
  end

  Faraday::Middleware.register_middleware logger: Logger
end
