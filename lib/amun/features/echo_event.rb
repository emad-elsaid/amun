require 'amun/event_manager'
require 'amun/ui/echo_area'

def log(event)
  # log valid strings only no control characters
  event = event.encode!('UTF-8', 'UTF-8', :invalid => :replace)
  Amun::UI::EchoArea.log "#{event}\n"
end
Amun::EventManager.bind_all nil, :log
