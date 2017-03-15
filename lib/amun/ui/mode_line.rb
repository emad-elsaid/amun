module Amun
  module UI
    class ModeLine
      def buffer
        @buffer ||= Amun::Application.instance.buffers.find { |b| b.mode_line == self }
      end

      def render(window)
        window.clear
        window << buffer.major_mode.class.name
      end
    end
  end
end
