require 'amun/version'
require 'amun/event_manager'
require 'amun/ui/echo_area'
require 'amun/ui/buffer'
require 'curses'

module Amun
  # singleton class that represent the current Amun application
  class Application
    attr_accessor :events, :buffers, :echo_area, :ui, :window

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
      ui.trigger(event) && events.trigger(event)
    rescue StandardError => e
      echo_area.echo "#{e.message} (#{e.backtrace.first})"
    ensure
      render
    end

    def error
      raise 'sdflkdsjflk'
    end

    private

    def initialize(events: EventManager.new)
      self.events = events
      self.buffers = []
      self.window = screen.subwin(Curses.lines - 1, Curses.cols, 0, 0)

      events.bind "\C-c", self, :quit
      events.bind "x", self, :error
      # events.bind_all self, :write_char
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
      self.ui = Amun::UI::Buffer.new
      buffers << ui
    end

    def render
      # x = screen.curx
      # y = screen.cury
      ui.render(window)
      echo_area.render
      # screen.setpos y, x
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
