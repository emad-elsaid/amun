require 'amun/version'
require 'amun/event_manager'
require 'amun/ui/echo_area'
require 'curses'

module Amun
  # singleton class that represent the current Amun application
  class Application
    attr_accessor :keyboard, :events, :echo_area

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
      init_ui

      echo_area.echo 'Press ESC to exit.'

      Thread.new do
        while ch = screen.get_char
          keyboard.trigger(ch)
          echo_area.refresh
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

    def init_ui
      self.echo_area = Amun::UI::EchoArea.new
    end
  end
end
