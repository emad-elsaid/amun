require_relative './variables'

def forward_char(*)
  current_buffer.point += 1
  true
end

def backward_char(*)
  current_buffer.point -= 1
  true
end

def next_line(*)
  point = current_buffer.point

  line_begin = current_buffer.rindex(/^/, point)

  line_end = current_buffer.index(/$/, point)
  return true if line_end == current_buffer.size

  next_line_end = current_buffer.index(/$/, line_end + 1)
  point_offset = point - line_begin
  current_buffer.point = [line_end + 1 + point_offset, next_line_end].min
  true
end

def previous_line(*)
  point = current_buffer.point

  line_begin = if point == current_buffer.size && current_buffer[point - 1] == "\n"
                 point
               else
                 current_buffer.rindex(/^/, point)
               end
  return true if line_begin.zero?

  previous_line_begin = current_buffer.rindex(/^/, line_begin - 1)

  point_offset = point - line_begin
  current_buffer.point = [previous_line_begin + point_offset, line_begin - 1].min
  true
end

def beginning_of_line(*)
  point = current_buffer.point
  return true if point == current_buffer.size && current_buffer[point - 1] == "\n"

  line_start = current_buffer.rindex(/^/, point)
  current_buffer.point = line_start <= point ? line_start : 0
  true
end

def end_of_line(*)
  point = current_buffer.point
  return true if current_buffer[point] == "\n"

  line_end = current_buffer.index("\n", point)
  current_buffer.point = line_end || current_buffer.length
  true
end
