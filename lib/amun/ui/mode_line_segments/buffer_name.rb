module Amun
  module UI
    module ModeLineSegments
      class BufferName
        def initialize(buffer)
          @buffer = buffer
        end

        def render(*)
          "#{@buffer.name} ".colorize(:mode_line)
        end
      end
    end
  end
end
