module Amun
  module UI
    module ModeLineSegments
      # display buffer name in modeline
      class BufferName
        def initialize(window)
          @window = window
        end

        def render
          "#{@window.buffer.name} ".colorize(:mode_line)
        end
      end
    end
  end
end
