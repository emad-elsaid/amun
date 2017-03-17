module Amun
  module UI
    module ModeLineSegments
      module BufferName
        module_function

        def render(buffer, _window)
          "#{buffer.name} ".colorize(:mode_line)
        end
      end
    end
  end
end
