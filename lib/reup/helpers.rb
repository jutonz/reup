module Reup
  module Helpers
    def rails?
      @on_rails ||= File.exist? "Procfile"
    end

    def ember?
      @on_ember ||= File.exist? "ember-cli-build.js"
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

    def serve
      serve_command =
        case env
        when :rails then "bundle exec foreman start"
        when :ember then "ember server"
        end

      run(serve_command, replace_process: true)
    end

    def env
      return :rails if rails?
      return :ember if ember?
    end

  end
end
