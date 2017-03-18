require 'curses'

require 'amun/version'
require 'amun/event_manager'
require 'amun/ui/buffer'
require 'amun/ui/windows/frame'

module Amun
  # singleton class that represent Amun application
  class Application
    attr_accessor :buffers, :current_buffer, :ui

    def self.instance
      @instance ||= new
    end

    def quit(_event)
      exit 0
    end

    def run
      init_curses
      init_ui
      ui.render
      keyboard_thread.join
    end

    private

    def initialize
      self.buffers = []

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

    def init_ui
      self.ui = Amun::UI::Windows::Frame.new
      self.current_buffer = Amun::UI::Buffer.new(name: '*Scratch*')
      buffers << current_buffer
    end

    def keyboard_thread
      Thread.new do
        while (ch = Curses.stdscr.get_char)
          ui.trigger(ch)
        end
      end
    end
  end
end
