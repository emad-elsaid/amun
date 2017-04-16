module Amun
  module Behaviours
    # inserting text to buffer behaviour and emacs keymap
    module Insertion
      def insertion_keymap_initialize
        bind_all self, :insert_char
      end

      def insert_char(char)
        return true unless char.is_a? String
        return true unless char.length == 1
        return true unless char.valid_encoding?
        return true unless char.match?(/[[:print:]\n\t]/)

        buffer.insert(buffer.point, char)
        buffer.point += 1

        true
      end
    end
  end
end
