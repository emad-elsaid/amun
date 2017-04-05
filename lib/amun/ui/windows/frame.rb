require 'curses'
require 'amun/event_manager'
require 'amun/ui/windows/buffer_window'
require 'amun/ui/echo_area'

module Amun
  module UI
    module Windows
      # a Frame fills all the space in terminal
      # renders an echo area or mini buffer if it exists
      # and an object that
      # respond to #render and #trigger, like buffer,
      # or another window or so
      class Frame
        attr_accessor :mini_buffer
        attr_writer :screen, :window

        def screen
          @screen ||= Curses.stdscr
        end

        def window
          @window ||= BufferWindow.new
        end

        def trigger(event)
          EventManager.join(event, bottom_area, window, EventManager)
        rescue StandardError => error
          handle_exception(error)
        end

        def render
          render_object_in_window(window, top_window)
          render_object_in_window(bottom_area, bottom_window)
        rescue StandardError => error
          handle_exception(error)
        end

        private

        def bottom_area
          mini_buffer || echo_area
        end

        def echo_area
          @echo_area ||= EchoArea.new
        end

        def top_window
          screen.subwin(
            screen.maxy - bottom_area.height, screen.maxx,
            screen.begy, screen.begx
          )
        end

        def bottom_window
          screen.subwin(
            bottom_area.height, screen.maxx,
            screen.maxy - bottom_area.height, 0
          )
        end

        def render_object_in_window(object, curses_window)
          object.render(curses_window)
        rescue StandardError => error
          handle_exception(error)
        ensure
          curses_window.refresh
          curses_window.close
        end

        def handle_exception(e)
          EchoArea.log "#{e.message} (#{e.backtrace.first})\n"
        end
      end
    end
  end
end
