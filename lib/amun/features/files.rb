require 'amun/event_manager'
require 'amun/buffer'
require 'amun/mini_buffer'

class FindFileBuffer < Amun::MiniBuffer
  def initialize
    super 'Open file: '
    self << Dir.pwd
    self.point = length
    events.bind "done", self, :open_file
  end

  def open_file(*)
    file_buffer = Amun::Buffer.new(text, File.open(text, 'r+'))
    Amun::Buffer.instances << file_buffer
    Amun::Buffer.current = file_buffer
  end
end

def find_file(*)
  FindFileBuffer.new.attach
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
