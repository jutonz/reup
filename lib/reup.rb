require_relative "reup/helpers"
require_relative "reup/version"
require_relative "reup/user_settings"
require "fileutils"

module Reup
  DEFAULT_SETTINGS_PATH = File.expand_path "../reup/.reup.yaml", __FILE__
  USER_SETTINGS_PATH    = File.expand_path ".reup.yaml", Dir.home
end

include Reup
include Reup::Helpers
include Reup::UserSettings
