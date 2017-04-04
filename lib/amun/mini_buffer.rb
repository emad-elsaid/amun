require 'amun/application'
require 'amun/buffer'
require 'amun/event_manager'

module Amun
  class MiniBuffer < Buffer
    def initialize(name)
      bind_events
      super name
    end

    def height
      text.strip.count("\n") + 1
    end

    def attach(frame = Amun::Application.frame)
      @frame = frame
      @frame.mini_buffer = self
    end

    def detach
      @frame.mini_buffer = nil
      @frame = nil
    end

    def attached?
      @frame && @frame.mini_buffer == self
    end

    def trigger(event)
      super
      EventManager::INTERRUPTED
    end

    def render(curses_window)
      curses_window.clear
      curses_window << name
      render_major_mode(curses_window) if curses_window.maxx > name.length
    end

    def cancel(*)
      detach
      events.trigger("cancel")
      self.text = nil
    end

    def done(*)
      detach
      events.trigger("done")
      self.text = nil
    end

    private

    def render_major_mode(curses_window)
      mode_curses_window = curses_window.subwin(
        curses_window.maxy, curses_window.maxx - name.length,
        curses_window.begy, curses_window.begx + name.length
      )
      major_mode.render(mode_curses_window)
    ensure
      mode_curses_window.close
    end

    def bind_events
      events.bind "\e", self, :cancel
      events.bind "\C-g", self, :cancel
      events.bind "\n", self, :done
    end
  end
end
