def insert_char(char)
  return true unless char.is_a? String
  return true unless char.length == 1
  return true unless char.valid_encoding?
  return true unless char.match?(/[[:print:]\n\t]/)

  current_buffer.insert(current_buffer.point, char)
  current_buffer.point += 1

  true
end
