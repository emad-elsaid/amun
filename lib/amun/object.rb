require 'amun/event_manager'
require 'forwardable'

module Amun
  # an object wrapping event manager inside it
  # and exposing every method to the public
  # this way you can have this object and switch
  # behavior and states by switching internal event manager
  # instances, for example you can have a mode that switch between
  # normal and insert mode (ahem ahem VIM style)
  class Object
    extend Forwardable

    attr_accessor :events
    def_delegators :events, :bind, :bind_all, :unbind, :unbind_all, :trigger

    def initialize
      @events = EventManager.new
    end
  end
end
