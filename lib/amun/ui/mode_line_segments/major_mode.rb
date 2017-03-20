module Amun
  module UI
    module ModeLineSegments
      class MajorMode
        def initialize(buffer)
          @buffer = buffer
        end

        def render(*)
          mode = @buffer.major_mode.class.name.split('::').last
          "(#{mode}) ".colorize(:mode_line)
        end
      end
    end
  end
end
