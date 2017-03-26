require 'amun/event_manager'

def kill_amun(*)
  exit 0
end
Amun::EventManager.bind("\C-x \C-c", nil, :kill_amun)
