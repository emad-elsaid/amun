require 'remacs/version'
require 'remacs/event_manager'
require 'curses'

module Remacs
  module_function

  class Application
    attr_accessor :keyboard, :events

    def self.instance
      @instance ||= new
    end

    def quit(_event)
      exit 0
    end

    def write_char(char)
      screen.addstr(char.to_s)
    end

    def run
      init_curses
      screen << "Press ESC to exit.\n"

      Thread.new do
        while ch = screen.get_char
          keyboard.trigger(ch)
          screen.refresh
        end
      end.join
    end

    def screen
      @screen ||= Curses.stdscr
    end

    private

    def initialize(keyboard = EventManager.new, events: EventManager.new)
      self.keyboard = keyboard
      self.events = events

      keyboard.bind "\e", self, :quit
      keyboard.bind_all self, :write_char
    end

    def init_curses
      Curses.init_screen
      Curses.raw
      Curses.noecho
      Curses.start_color
      Curses.stdscr.keypad(true)
      Curses.ESCDELAY = 0
    end
  end
end
