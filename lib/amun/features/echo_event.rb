require 'amun/event_manager'

def log(event)
  Amun::Application.instance.frame.echo_area.echo event
end
Amun::EventManager.bind_all nil, :log
