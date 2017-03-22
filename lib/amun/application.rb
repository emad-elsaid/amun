require 'curses'
require 'singleton'
require 'amun/event_manager'
require 'amun/ui/windows/frame'

module Amun
  # singleton Amun application, it initialize curses,
  # have the frame and handles keyboard
  class Application
    include Singleton

    attr_writer :frame

    def frame
      @frame ||= Amun::UI::Windows::Frame.new
    end

    def run
      init_curses
      frame.render
      keyboard_thread.join
    end

    def quit(*)
      exit 0
    end

    private

    def initialize
      Amun::EventManager.bind "\C-c", self, :quit
    end

    def init_curses
      Curses.init_screen
      Curses.curs_set 0
      Curses.raw
      Curses.noecho
      Curses.start_color
      Curses.stdscr.keypad(true)
      Curses.ESCDELAY = 0
    end

    def keyboard_thread
      Thread.new do
        chain = []
        while (ch = Curses.stdscr.get_char)
          chain << ch
          if EventManager.join(chain.join(' '), frame) != EventManager::CHAINED
            chain.clear
          end
        end
      end
    end
  end
end
