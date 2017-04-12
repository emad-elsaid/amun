require 'amun/event_manager'
require 'amun/buffer'
require 'amun/windows/mini_buffer_window'

def find_file(*)
  Amun::Windows::MiniBufferWindow.new('Open file: ', Dir.pwd) do |window|
    file_path = window.buffer.to_s

    file_buffer = Amun::Buffer.new(file_path, File.open(file_path, 'r+'))
    Amun::Buffer.instances << file_buffer
    Amun::Buffer.current = file_buffer
  end.attach(Amun::Application.frame)

  true
end

Amun::EventManager.bind "\C-x \C-f", nil, :find_file

unless ARGV.empty?
  ARGV.each do |file|
    file_buffer = Amun::Buffer.new(file, File.open(file, 'r+'))
    Amun::Buffer.instances << file_buffer
    Amun::Buffer.current = file_buffer
    Amun::Application.frame.render
  end
end
