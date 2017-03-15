require 'amun/version'
require 'amun/event_manager'
require 'amun/ui/echo_area'
require 'curses'

module Amun
  # singleton class that represent the current Amun application
  class Application
    attr_accessor :events, :echo_area

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

      keyboard_thread.join
    end

    def screen
      @screen ||= Curses.stdscr
    end

    def trigger(event)
      events.trigger(event)
    rescue StandardError => e
      echo_area.echo "#{e.message} (#{e.backtrace.first})"
    ensure
      refresh_ui
    end

    private

    def initialize(events: EventManager.new)
      self.events = events

      events.bind "\C-c", self, :quit
      events.bind_all self, :write_char
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

    def refresh_ui
      x = screen.curx
      y = screen.cury
      echo_area.refresh
      screen.setpos y, x
    end

    def keyboard_thread
      Thread.new do
        while (ch = screen.get_char)
          trigger(ch)
        end
      end
    end
  end
end
