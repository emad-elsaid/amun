require 'amun/event_manager'

module Amun
  module Features
    module Quit
      def self.quit(*)
        exit 0
      end
    end
  end
end
Amun::EventManager.bind("\C-c", Amun::Features::Quit, :quit)
