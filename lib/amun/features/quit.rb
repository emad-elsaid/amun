require 'amun/event_manager'

module QuitAmun
  def self.quit(*)
    exit 0
  end
end
Amun::EventManager.bind("\C-c", QuitAmun, :quit)
