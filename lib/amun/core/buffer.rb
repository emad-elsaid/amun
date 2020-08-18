$current_buffer = nil

def current_buffer
  $current_buffer
end

def set_current_buffer(buffer)
  $current_buffer = buffer
end

def open_buffer(buffer)
  Amun::Buffer.instances << buffer
  set_current_buffer(buffer)
  Amun::Application.frame.window.buffer = buffer
end
