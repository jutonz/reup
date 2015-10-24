module Reup
  module UserSettings
    def initialize_user_settings
      FileUtils.cp DEFAULT_SETTINGS_PATH, USER_SETTINGS_PATH
    end
  end
end
