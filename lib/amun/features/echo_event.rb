require 'amun/event_manager'

def log(event)
  Amun::UI::Buffer.messages.text << "#{event}\n"
end
Amun::EventManager.bind_all nil, :log
