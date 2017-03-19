require 'curses'
require 'set'

require 'amun/version'
require 'amun/event_manager'
require 'amun/ui/buffer'
require 'amun/ui/windows/frame'

module Amun
  # singleton class that represent Amun application
  class Application
    attr_accessor :buffers
    attr_writer :frame, :current_buffer

    def self.instance
      @instance ||= new
    end

    def quit(*)
      exit 0
    end

    def run
      init_curses
      frame.render
      keyboard_thread.join
    end

    def frame
      @frame ||= Amun::UI::Windows::Frame.new
    end

    def current_buffer
      @current_buffer || scratch
    end

    def scratch
      @scratch ||= Amun::UI::Buffer.new(name: '*Scratch*')
      buffers << @scratch
      @scratch
    end

    private

    def initialize
      self.buffers = Set.new
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
        while (ch = Curses.stdscr.get_char)
          frame.trigger(ch)
        end
      end
    end
  end
end
