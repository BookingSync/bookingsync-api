module BookingSync::API::Middleware
  # Provides faraday middleware for authentication using OAuth token
  # We don't use default FaradayMiddleware::OAuth2 because
  # it adds access_token param to the URL
  class Authentication < Faraday::Middleware
    def initialize(app, token)
      @app = app
      @token = token
    end

    def call(env)
      env[:request_headers]["Authorization"] = "Bearer #{@token}"
      @app.call(env)
    end
  end

  Faraday::Middleware.register_middleware authentication: Authentication
end
