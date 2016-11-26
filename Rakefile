begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"
task default: :spec
RSpec::Core::RakeTask.new

require "bookingsync/stylecheck"
load "bookingsync/tasks/stylecheck.rake"
