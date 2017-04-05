require 'amun/event_manager'
require 'amun/ui/echo_area'

def log(event)
  Amun::UI::EchoArea.log "#{event}\n"
end
Amun::EventManager.bind_all nil, :log
