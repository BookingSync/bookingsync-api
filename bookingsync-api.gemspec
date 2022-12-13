lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bookingsync/api/version"

Gem::Specification.new do |spec|
  spec.name          = "bookingsync-api"
  spec.version       = BookingSync::API::VERSION
  spec.authors       = ["Sébastien Grosjean"]
  spec.email         = ["dev@bookingsync.com"]
  spec.summary       = %q{Ruby interface for accessing https://www.bookingsync.com}
  spec.description   = %q{This gem allows to interact with the BookingSync API via Ruby objects}
  spec.homepage      = "https://github.com/BookingSync/bookingsync-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2"
  spec.add_dependency "faraday-net_http_persistent", ">= 2.0.2"
  spec.add_dependency "net-http-persistent", [">= 4.0.1", "< 5.0"]
  spec.add_dependency "hashie"
  spec.add_dependency "addressable"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "bookingsync-stylecheck"
end
