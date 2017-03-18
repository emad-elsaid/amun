require 'curses'

require 'amun/event_manager'
require 'amun/ui/echo_area'

module Amun
  module UI
    module Windows
      class Frame
        attr_accessor :echo_area

        def initialize
          self.echo_area = Amun::UI::EchoArea.new
        end

        def trigger(event)
          echo_area.trigger(event) &&
            buffer.trigger(event) &&
            Amun::EventManager.trigger(event)
        rescue StandardError => e
          echo_area.echo "#{e.message} (#{e.backtrace.first})"
        ensure
          echo_area_window.refresh
          buffer_window.refresh
          screen.refresh
        end

        def render
          buffer.render(buffer_window)
          echo_area.render(echo_area_window)
        rescue StandardError => e
          echo_area.echo "#{e.message} (#{e.backtrace.first})"
        ensure
          screen.refresh
        end

        private

        def buffer
          Amun::Application.instance.current_buffer
        end

        def screen
          @screen ||= Curses.stdscr
        end

        def buffer_window
          @buffer_window ||= screen.subwin(Curses.lines - 1, Curses.cols, 0, 0)
        end

        def echo_area_window
          @echo_area_window ||= Curses::Window.new(1, Curses.cols, Curses.lines - 1, 0)
        end
      end
    end
  end
end
