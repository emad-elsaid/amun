require 'amun/version'
require 'amun/event_manager'
require 'amun/ui/echo_area'
require 'amun/ui/buffer'
require 'curses'

module Amun
  # singleton class that represent the current Amun application
  class Application
    attr_accessor :events, :buffers, :echo_area, :ui

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

    def window
      @window ||= screen.subwin(Curses.lines - 1, Curses.cols, 0, 0)
    end

    def trigger(event)
      ui.trigger(event) && events.trigger(event)
    rescue StandardError => e
      echo_area.echo "#{e.message} (#{e.backtrace.first})"
    ensure
      render
    end

    private

    def initialize(events: EventManager.new)
      self.events = events
      self.buffers = []

      events.bind "\C-c", self, :quit
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
      Curses.curs_set 0
      ui.render(window)
      echo_area.render
      window.refresh
      Curses.curs_set 1
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
