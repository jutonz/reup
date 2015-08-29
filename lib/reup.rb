require "slop"
require "cocaine"
require "byebug"

require_relative "reup/version"
require_relative "reup/helpers"

include Reup::Helpers

options = Slop.parse do |option|
  option.bool "-r", "--resetdb", "resets the database"
  option.string "-b", "--branch", "checkout branch"
  option.on "-v", "--version", "print the version" do
    puts Reup::VERSION
    exit
  end
end

run "git checkout #{options[:branch]}", quiet: true if options.branch?
run "git pull"

if rails?
  run "bundle"
  run "rake db:migrate:reset" if options.resetdb?
  serve
elsif ember?
  run "npm install"
  serve
end

