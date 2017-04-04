require 'curses'

module Amun
  module Helpers
    ##
    # Colors is responsible for registering new colors
    # pairs (foreground and background)
    # associate the pair with a name, then #use that pair
    # for the next text printed
    # on screen, also contains styles constants could be
    # passed to #use to print bold
    # or underline text for example
    #
    # it's important to understand that the number of pairs
    # that coul'd be registered
    # is limited to a number the current terminal specify,
    # so registering, more color
    # pairs than allowed will result in a RuntimeError.
    #
    # color values could be taken from the xterm-256 color schema from here:
    # https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
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
      DEFAULT_COLOR = :default
      private_constant :COLORS

      # register or update a color pair with *foreground* and *background*
      # colors, this method will raise RuntimeError if we exceeded the limit
      # of color pairs allowed by the terminal
      # name(Symbol):: name of pair, could be used with the #use method
      # foreground(Number):: foreground color in current terminal color schema
      # background(Number):: background color in current terminal color schema
      def register(name, foreground, background)
        if COLORS.size >= Curses.color_pairs - 1
          raise "Can't register color: #{name}, max: #{Curses.color_pairs}"
        end

        Curses.init_pair(COLORS[name], foreground, background)
      end

      # check if a color pair is registered or not, returns true if registered
      def registered?(name)
        COLORS.key? name
      end

      # works like #register but doesn't override your color if it's already
      # registered, this is a better method for any
      # module to use to define colors
      # #register should be used for redefining a color pair values
      def register_default(name, foreground, background)
        return if registered? name
        register(name, foreground, background)
      end

      # use color pair for the next printed text
      # window(Curses Window):: that we need to change it's colors
      # name(Symbol):: a color pair name registered before with #register
      # type(Colors::Constant):: a text style constant
      # defined in Colors, that manipulate the text style
      # (Bold, Underline, Invert colors)
      def use(curses_window, name, type = NORMAL)
        index = COLORS.key?(name) ? COLORS[name] : 0
        curses_window.attron(Curses.color_pair(index) | type)
      end

      # print string in Curses window in the choosen color and style
      def print(curses_window, *strings)
        strings.each do |string|
          use(curses_window, string.color || DEFAULT_COLOR, string.style || NORMAL)
          curses_window << string
        end
      end
    end
  end
end

# for easier printing of colored string on the screen
# we can add color property to any string and then
# use it to print the string on the screen
class String
  attr_accessor :color, :style

  def colorize(color, style = Amun::Helpers::Colors::NORMAL)
    self.color = color
    self.style = style
    self
  end
end
