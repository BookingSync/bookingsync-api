guard :rspec do
  watch(%r{^lib/bookingsync/(.+)\.rb$})             { |m| "spec/bookingsync/#{m[1]}_spec.rb" }
  watch(%r{^lib/bookingsync/api/client/(.+)\.rb$})  { |m| "spec/bookingsync/api/client/#{m[1]}_spec.rb" }
  watch(%r{^lib/bookingsync/api/(.+)\.rb$})         { |m| "spec/bookingsync/api/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

guard 'yard' do
  watch(%r{lib/.+\.rb})
end
