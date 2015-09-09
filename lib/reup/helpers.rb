require "yaml"

module Reup
  module Helpers

    ENV_FILE = File.expand_path "../env.yaml", __FILE__

    ###########################################################################
    # Executable helpers
    ###########################################################################

    def run(command, quiet: false, print_command: true, replace_process: false)
      return unless command
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
      result
    end

    def kernel_run(command)
      Kernel.exec command
    end

    def detect_change_to(files, &block)
      before = files.map { |f| last_modified(f) }
      yield
      after  = files.map { |f| last_modified(f) }
      before != after # Not equal means there was a change
    end

    ###########################################################################
    # Environment helpers
    ###########################################################################

    def last_modified(file)
      File.mtime file
    end

    def env_file
      @env_file ||= YAML.load_file ENV_FILE
    end

    def watch_files
      @watch_files ||= Array(env_file[env]["install"]["only_if_changed"])
    end

    def install_command
      @install_command ||= env_file[env]["install"]["command"]
    end

    def serve_command
      @serve_command ||= env_file[env]["serve"]["command"]
    end

    def reset_db_command
      @reset_db_command ||= (
        db_section = env_file[env]["db"]
        if db_section
          db_section["reset_command"]
        else
          nil
        end
      )
    end

    def env
      @env ||= (
        possible_envs = env_file.keys
        env = nil
        possible_envs.each do |possible|
          indicator_files = Array(env_file[possible]["indicator_files"])
          if indicator_files.any? { |f| File.exist? f }
            env = possible
            break
          end
        end
        raise "You don't appear to be in a supported environment" unless env
        env
      )
    end

    ###########################################################################
    # API methods
    ###########################################################################

    def install(args = {})
      run install_command, args
    end

    def reset_db(args = {})
      run reset_db_command, args
    end

    def serve
      run(serve_command, replace_process: true)
    end

  end
end
