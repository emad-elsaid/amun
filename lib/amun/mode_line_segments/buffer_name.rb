module Amun
  module ModeLineSegments
    # display buffer name in modeline
    class BufferName
      def render(buffer)
        " #{buffer.name} ".colorize(:mode_line)
      end
    end
  end
end
