require 'amun/helpers/colors'

module Amun
  module UI
    class ModeLine
      def render(buffer, window)
        mode = buffer.major_mode.class.name.split('::').last
        window.attron(Amun::Helpers::Colors::REVERSE)
        window << mode
        window << ' ' * (window.maxx - mode.size)
      end
    end
  end
end
