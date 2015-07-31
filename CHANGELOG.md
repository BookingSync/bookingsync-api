# Changelog

## master

## 0.0.28

- Add missing dependency of `addressable`

## 0.0.27

- Add support for fetching a single booking with options (needed to fetch canceled bookings)

## 0.0.26

- Add support for creating instant bookings
- Add support for creatings rentals amenities

## 0.0.25

- Add support for Accounts endpoint

## 0.0.24

- Add support for fetching a single availability
- Add support for polymorphic associations
- Add support for Taxes, Fees, BookingsTaxes, BookingsFees and RentalsFees endpoints

## 0.0.23

- Add BookingSync::Engine::APIClient that automatically refreshes token on 401 expired responses.

## 0.0.22

- Handle 403 responses from the API. Raises BookingSync::API::Forbidden
