guard :rspec, cmd: "bundle exec rspec --format p" do
  watch(%r{^spec/(.+)_spec\.rb$})
  watch(%r{^lib/bookingsync/(.+)\.rb$})             { |m| "spec/bookingsync/#{m[1]}_spec.rb" }
  watch(%r{^lib/bookingsync/api/client/(.+)\.rb$})  { |m| "spec/bookingsync/api/client/#{m[1]}_spec.rb" }
  watch(%r{^lib/bookingsync/api/(.+)\.rb$})         { |m| "spec" }
  watch("spec/spec_helper.rb")  { "spec" }
end
