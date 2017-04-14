require 'amun/object'
require 'forwardable'
require 'curses'

module Amun
  module Windows
    class Base < Object
      extend Forwardable

      attr_reader :size
      def_delegators :size, :top, :left, :width, :height

      def initialize(size)
        super()
        @size = size
        @curses_window = Curses.stdscr.subwin(height, width, top, left)
      end

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
