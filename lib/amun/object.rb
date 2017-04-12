require 'amun/event_manager'
require 'forwardable'

module Amun
  class Object
    extend Forwardable

    attr_accessor :events
    def_delegators :events, :bind, :bind_all, :unbind, :unbind_all, :trigger

    def initialize
      @events = EventManager.new
    end
  end
end
