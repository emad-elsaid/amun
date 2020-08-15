require 'amun/object'
require 'forwardable'
require 'curses'

module Amun
  module Windows
    # based on amun object, means it has event manager inside
    # and respond to all event manager methods (bind, undind, trigger...etc)
    # and has a size (Rect instance), it also expose the methods of the size
    # to the public, it also creates a subwindow from the curses standard screen
    # and resizes it whenever you set a new (size) value
    class Base < Object
      extend Forwardable

      attr_reader :size

      def_delegators :size, :top, :left, :width, :height

      def initialize(size)
        super()
        @size = size
        @curses_window = Curses.stdscr.subwin(height, width, top, left)
      end

      # change the object size
      # the internal curses window will be
      # resized and moved along with it
      def size=(size)
        @size = size
        resize
      end

      private

      attr_accessor :curses_window

      def resize
        curses_window.resize(height, width)
        curses_window.move(top, left)
      end
    end
  end
end
