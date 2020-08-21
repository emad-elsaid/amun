require 'singleton'
require 'forwardable'

module Amun
  # singleton Amun application, it initialize curses,
  # have the frame and handles keyboard
  class Application
    include Singleton

    attr_writer :frame

    def frame
      @frame ||= Windows::Frame.new
    end

    def run
      init_curses

      frame.render
      set_current_buffer(frame.window.buffer)

      load_config
      keyboard_thread.join
    end

    class << self
      extend Forwardable
      def_delegators :instance,
                     :run, :frame, :frame=
    end

    private

    def init_curses
      Curses.init_screen
      Curses.curs_set 0
      Curses.raw
      Curses.noecho
      Curses.start_color
      Curses.stdscr.keypad = true
      Curses.ESCDELAY = 0
    end

    def keyboard_thread
      Thread.new do
        chain = []
        while (ch = Helpers::Keyboard.char)
          chain << ch
          chain.clear if frame.trigger(chain.join(' ')) != EventManager::CHAINED
          frame.render
        end
      end
    end
  end
end
