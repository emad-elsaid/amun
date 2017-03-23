require 'amun/event_manager'

def quit(*)
  exit 0
end
Amun::EventManager.bind("\C-c", nil, :quit)
