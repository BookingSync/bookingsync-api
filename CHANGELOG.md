# Changelog

# master

## 1.0.0

- Drop support for ruby prior to 2.7
- Add support for ruby 3.0 and 3.1
- Update and lock faraday at `~> 2`

## 0.2.0 - 2022-01-10
- upgrade net-http-persistent to be ruby 3 ready

## 0.1.14 - 2019-10-15
- Add supports for `rental_urls` endpoint.

## 0.1.13 - 2019-10-08
- Add supports for `contacts` endpoint.

## 0.1.12 - 2018-05-25
- updated Faraday and Net HTTP Persistent gem to remove workaround

## 0.1.11 - 2018-05-18
- Added `add_attachment_to_message`.

## 0.1.10 - 2018-05-17
- Added support for `attachments`.

## 0.1.9 - 2018-04-30

- Enable dynamic override of headers per request.
- Add support for `inbox` endpoints.

## 0.1.8 - 2017-12-05

- Add support for `bookings_tags` endpoint.
- Add support for `rentals_contents_overrides` endpoint.

## 0.1.7 - 2017-11-30

- Add workaround to avoid `Net::HTTP::Persistent too many connection resets error`

## 0.1.6 - 2017-10-30

- Add support for addition and removal of bookings_fees

## 0.1.5

- `Bookings#cancel_booking` supports passing attributes in body.

## 0.1.4

- Drop support for `preferences_payments`.
- Switch from `Net::HTTP` to `Net::HTTP::Persistent`.
- [bugfix] Fix bug when paginate with block didn't invoke it, if only one page of results was returned.

## 0.1.3

- Expose pagination_first_request to easily retrieve right timestamps for updated since syncs.
- Add support for `living_rooms`.

## 0.1.2

- Add support for `payment_gateways`.
- Add support for `nightly_rate_maps`.

## 0.1.1

- Add support for `change_overs`.

## 0.1.0

- Drop support for Ruby 1.9.3 and Ruby 2.0.x
- Add support for pagination with POST method
- Use POST pagination for `rentals_search` by default

## 0.0.36

- Add support for `booking_comments`.

## 0.0.35

- Add support for preferences_general_settings reading and updating.

## 0.0.34

- Fixed documentation urls
- Add support for rental_cancelation_policies and rental_cancelation_policy_items endpoints.
- Rename instant bookings to strict bookings
- Raise RateLimitExceeded error for 429 response status.

## 0.0.32

- Add support for preferences_payments endpoint.

## 0.0.31

- Add support for fees and rentals_fees creation.

## 0.0.30

- Add missing CRUD actions to existing endpoints.
- Remove unused BillingAddresses endpoint.

## 0.0.29

- Add support for Bathrooms and Bedrooms endpoints.

## 0.0.28

- Add missing dependency of `addressable`.

## 0.0.27

- Add support for fetching a single booking with options (needed to fetch canceled bookings).

## 0.0.26

- Add support for creating instant bookings.
- Add support for creatings rentals amenities.

## 0.0.25

- Add support for Accounts endpoint.

## 0.0.24

- Add support for fetching a single availability.
- Add support for polymorphic associations.
- Add support for Taxes, Fees, BookingsTaxes, BookingsFees and RentalsFees endpoints.

## 0.0.23

- Add BookingSync::Engine::APIClient that automatically refreshes token on 401 expired responses.

## 0.0.22

- Handle 403 responses from the API. Raises BookingSync::API::Forbidden.
