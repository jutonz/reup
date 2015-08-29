require "commander"

module Reup
  class CLI
    include Commander::Methods

    def run
      program :name, "reup"
      program :version, VERSION
      program :description, "Restarts servers and other things"
      binding.pry

      program.action do |args, options|
        cmd = Cocaine::CommandLine.new("echo #{args}")
        puts cmd.run
      end


      run!
    end

  end
end
