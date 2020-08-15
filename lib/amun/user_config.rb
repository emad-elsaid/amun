module Amun
  # UserConfig will load ruby file localed in `~/.amun/init.rb`
  module UserConfig
    def self.call
      init_file = File.join(Dir.home, '.amun', 'init.rb')
      require init_file if File.exist?(init_file)
    end
  end
end
