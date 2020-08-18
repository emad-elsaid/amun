def mode_line_buffer_name(buffer)
  " #{buffer.name} ".colorize(:mode_line)
end

def mode_line_major_mode_name(buffer)
  mode = buffer.major_mode.class.name.split('::').last
  " (#{mode}) ".colorize(:mode_line)
end
