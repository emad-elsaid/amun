module Amun
  module UI
    module ModeLineSegments
      # display major mode name in mode line
      class MajorMode
        def initialize(window)
          @window = window
        end

        def render
          mode = @window.buffer.major_mode.class.name.split('::').last
          "(#{mode}) ".colorize(:mode_line)
        end
      end
    end
  end
end
