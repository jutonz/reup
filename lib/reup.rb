require "pry"
require "slop"
require "cocaine"

require "reup/version"

options = Slop.parse do |option|
  option.on "-v", "--version", "print the version" do
    puts Reup::VERSION
    exit
  end
end

cmd = Cocaine::CommandLine.new("git status")
puts cmd.run
