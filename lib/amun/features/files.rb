require 'amun/event_manager'
require 'amun/ui/buffer'
require 'amun/ui/mini_buffer'

class FindFileBuffer < Amun::UI::MiniBuffer
  def initialize
    super 'Open file: '
    self.text = Dir.pwd
    self.point = text.size
    events.bind "done", self, :open_file
  end

  def open_file(*)
    file_buffer = Amun::UI::Buffer.new(text, File.open(text, 'r+'))
    Amun::UI::Buffer.instances << file_buffer
    Amun::UI::Buffer.current = file_buffer
  end
end

def find_file(*)
  FindFileBuffer.new.attach
  true
end

Amun::EventManager.bind "\C-x \C-f", nil, :find_file
