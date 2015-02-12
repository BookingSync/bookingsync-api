# Changelog

## master

## 0.0.23

- Add BookingSync::Engine::APIClient that automatically refreshes token on 401 expired responses.

## 0.0.22

- Handle 403 responses from the API. Raises BookingSync::API::Forbidden
