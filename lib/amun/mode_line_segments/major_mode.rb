module Amun
  module ModeLineSegments
    # display major mode name in mode line
    class MajorMode
      def render(buffer)
        mode = buffer.major_mode.class.name.split('::').last
        " (#{mode}) ".colorize(:mode_line)
      end
    end
  end
end
