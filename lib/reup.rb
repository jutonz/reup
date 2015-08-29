require "slop"
require "cocaine"
require "byebug"

require_relative "reup/version"

options = Slop.parse do |option|
  option.bool "-r", "--resetdb", "resets the database"
  option.string "-b", "--branch", "checkout branch"
  option.on "-v", "--version", "print the version" do
    puts Reup::VERSION
    exit
  end
end

def run(command, quiet: false, print_command: true, replace_process: false)
  puts command if print_command
  command += " &>/dev/null" if quiet

  if replace_process
    kernel_run command
  else
    cocaine_run command, quiet: quiet
  end
end

def cocaine_run(command, quiet:)
  cmd = Cocaine::CommandLine.new(command)
  result = cmd.run
  puts result unless quiet
end

def kernel_run(command)
  Kernel.exec command
end

def rails?
  @on_rails ||= File.exist? "Procfile"
end

def ember?
  @on_ember ||= File.exist? "ember-cli-build.js"
end

def serve
  run("bundle exec foreman start", replace_process: true) if rails?
  run("ember server", replace_process: true) if ember?
end

if options.branch?
  run "git checkout #{options[:branch]}", quiet: true
end

run "git pull"
if rails?
  run "bundle"
  run "rake db:migrate:reset" if options.resetdb?
  serve
elsif ember?
  run "npm install"
  serve
end

