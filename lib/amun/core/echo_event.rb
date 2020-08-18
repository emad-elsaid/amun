def log(event)
  # log valid strings only no control characters
  event = event.encode!('UTF-8', 'UTF-8', invalid: :replace)
  Amun::Buffer.messages << "#{event}\n"
end
Amun::EventManager.bind_all nil, :log
