require 'remacs/version'
require 'remacs/event_manager'
require 'remacs/helpers/keyboard'
require 'remacs/helpers/colors'
require 'curses'

module Remacs
  module_function

  class Application
    attr_accessor :keyboard

    def self.instance
      @instance ||= new
    end

    def quit(_event)
      exit 0
    end

    def write_char(char)
      Curses.stdscr.addstr(Curses.keyname(char))
    end

    def run
      init_curses

      Helpers::Colors.register(:title, 221, 0)
      Helpers::Colors.use :title

      Thread.new do
        while ch = Curses.stdscr.getch
          keyboard.trigger(ch)
          Curses.stdscr.refresh
        end
      end.join
    end

    private

    def initialize(keyboard = EventManager.new)
      self.keyboard = keyboard

      keyboard.bind Helpers::Keyboard.key2event("\C-c"), self, :quit
      keyboard.bind_all self, :write_char
    end

    def init_curses
      Curses.init_screen
      Curses.raw
      Curses.noecho
      Curses.start_color
      Curses.stdscr.keypad(true)
    end
  end
end
