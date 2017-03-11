require 'curses'

module Remacs
  module Helpers
    module Colors
      module_function

      ALTCHARSET = Curses::A_ALTCHARSET
      COLOR = Curses::A_COLOR
      LOW = Curses::A_LOW
      STANDOUT = Curses::A_STANDOUT
      DIM = Curses::A_DIM
      NORMAL = Curses::A_NORMAL
      TOP = Curses::A_TOP
      BLINK = Curses::A_BLINK
      HORIZONTAL = Curses::A_HORIZONTAL
      PROTECT = Curses::A_PROTECT
      UNDERLINE = Curses::A_UNDERLINE
      BOLD = Curses::A_BOLD
      INVIS = Curses::A_INVIS
      REVERSE = Curses::A_REVERSE
      VERTICAL = Curses::A_VERTICAL
      CHARTEXT = Curses::A_CHARTEXT
      LEFT = Curses::A_LEFT
      RIGHT = Curses::A_RIGHT

      COLORS = Hash.new { |h, k| h[k] = h.length + 1 }
      private_constant :COLORS

      def register(name, foreground, background)
        if COLORS.size >= Curses.color_pairs - 1
          raise "Can't register color #{name} as the colors exceeded the limit #{Curses.color_pairs}"
        end

        Curses.init_pair(COLORS[name], foreground, background)
      end

      def use(name, type = NORMAL)
        index = COLORS.key?(name) ? COLORS[name] : 0
        Curses.attron(Curses.color_pair(index)| type)
      end

      def reset
        use nil
      end
    end
  end
end
