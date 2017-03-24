require 'amun/ui/buffer'
require 'amun/event_manager'
require 'curses'

def forward_char(*)
  Amun::UI::Buffer.current.point += 1
  true
end
Amun::EventManager.bind "\C-f", nil, :forward_char
Amun::EventManager.bind Curses::KEY_RIGHT.to_s, nil, :forward_char

def backward_char(*)
  Amun::UI::Buffer.current.point -= 1
  true
end
Amun::EventManager.bind "\C-b", nil, :backward_char
Amun::EventManager.bind Curses::KEY_LEFT.to_s, nil, :backward_char

def next_line(*)
  buffer = Amun::UI::Buffer.current
  line_begin = buffer.text.rindex("\n", buffer.point) || 0
  line_end = buffer.text.index("\n", buffer.point + 1) || buffer.text.size + 1
  next_line_end = buffer.text.index("\n", line_end + 1) || buffer.text.size + 1
  point_offset = buffer.point - line_begin
  buffer.point = [line_end + point_offset, next_line_end].min
  true
end
Amun::EventManager.bind "\C-n", nil, :next_line
Amun::EventManager.bind Curses::KEY_DOWN.to_s, nil, :next_line

def previous_line(*)
  buffer = Amun::UI::Buffer.current
  line_begin = buffer.text.rindex("\n", buffer.point) || 0
  previous_line_begin = buffer.text.rindex("\n", line_begin - 1) || 0
  point_offset = buffer.point - line_begin
  buffer.point = [previous_line_begin + point_offset, line_begin - 1].min
  true
end
Amun::EventManager.bind "\C-p", nil, :previous_line
Amun::EventManager.bind Curses::KEY_UP.to_s, nil, :previous_line
