require 'remacs/version'
require 'remacs/event_manager'
require 'curses'

module Remacs
  module_function

  class App
    attr_accessor :keyboard

    def self.instance
      @instance ||= new
    end

    def quit(_event)
      exit 0
    end

    def write_char(char)
      Curses.stdscr.addstr(char)
    end

    private

    def initialize(keyboard = EventManager.new)
      init_curses

      self.keyboard = keyboard
      keyboard.bind 'q', self, :quit
      keyboard.bind_all self, :write_char

      while ch = Curses.stdscr.getch
        keyboard.trigger(Curses.keyname(ch))
        Curses.stdscr.refresh
      end
    end

    def init_curses
      Curses.init_screen
      Curses.raw
      Curses.noecho
    end
  end
end
