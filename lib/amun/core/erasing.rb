def delete_char(*)
  current_buffer.slice!(buffer.point)
  true
end

def backward_delete_char(*)
  return true if current_buffer.point.zero?

  current_buffer.point -= 1
  current_buffer.slice!(current_buffer.point)
  true
end

def forward_delete_char(*)
  delete_char
end

# TODO: should move text to kill ring
def kill_line(*)
  if current_buffer[current_buffer.point] == "\n"
    current_buffer.slice!(current_buffer.point)
    return true
  end

  line_end = current_buffer.index(/$/, current_buffer.point)
  current_buffer.slice!(current_buffer.point, line_end - current_buffer.point)
  true
end

# TODO: should move text to kill ring
def kill_word(*)
  first_non_letter = current_buffer.index(/\P{L}/, current_buffer.point) || current_buffer.length
  word_beginning = current_buffer.index(/\p{L}/, first_non_letter) || current_buffer.length
  current_buffer.slice!(current_buffer.point, word_beginning - current_buffer.point)
  true
end

# This should be bound to \M-BACKSPACE or \M-DEL but I think the terminal doesn't send it
# So the implementation will remain there until we find a way to catch this key
#
# TODO: should move text to kill ring
def backward_kill_word(*)
  first_letter_backward = current_buffer.rindex(/\p{L}/, current_buffer.point) || 0
  first_non_letter_before_word = current_buffer.rindex(/\P{L}/, first_letter_backward) || -1
  current_buffer.slice!(first_non_letter_before_word + 1..current_buffer.point)
  true
end
