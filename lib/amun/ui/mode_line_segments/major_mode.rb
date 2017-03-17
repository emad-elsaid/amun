module Amun
  module UI
    module ModeLineSegments
      module MajorMode
        module_function

        def render(buffer, _window)
          "(#{buffer.major_mode.class.name.split('::').last}) ".colorize(:mode_line)
        end
      end
    end
  end
end
