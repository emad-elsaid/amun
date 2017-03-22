require 'forwardable'
require 'set'

module Amun
  # = Event manager
  # Stores a stack of methods to call for each event,
  # when an event is triggered it executes methods in Last-In-First-Out
  # if a method returned true it continue execution of the next item in stack,
  # if the method returned false it will stop executing the rest of stack.
  #
  # == Usage
  # could be used to register keyboard events, registering a set of actions to
  # be executed when a key combination is pressed, the stack implementation will
  # help stop execution at certain action if it needs to hijack that key.
  #
  # Also could be used to as instrumentation tool between modules, some modules
  # register for event, and others fire it when happens, e.g *Window*
  # module needs to update it's title when a file is saved, so it
  # register *update_title* method to *after_file_save* event,
  # when the *Buffer* module saves a file it should trigger
  # that event, which executed the *update_title*.
  class EventManager
    # Event is interrupted and no need to continue
    INTERRUPTED = :interrupted
    # Event is to be continued
    CONTINUE = :continue
    # Event needs to be chained, will wait for next event
    CHAINED = :chained

    def initialize
      @bindings = Hash.new { |h, k| h[k] = [] }
      @chains = Set.new
    end

    # register an *objects*' *method* to be executed
    # when the *event* is triggered
    #
    # event(String):: and event to bind the method to
    # object(Object):: an object or class, that respond to +method+
    # method(Symbol):: a method name that should be executed when the event
    # is triggered
    def bind(event, object, method)
      unless object.respond_to? method
        raise ArgumentError, "#{method} : is not a method for #{object}"
      end

      add_chain(event)
      @bindings[event].unshift(object: object, method: method)
    end

    # remove all occurence of *method* from the *event* stack
    #
    # event(String):: the event name
    # object(Object):: object that we #bind it's method before
    # method(Symbol):: method name we #bind before
    def unbind(event, object, method)
      @bindings[event].delete_if do |binding|
        binding[:object] == object && binding[:method] == method
      end
      @bindings.delete(event) if @bindings[event].empty?
      update_chains
    end

    # bind an object method to be executed when any event is triggered
    # it uses a stack called *all* to register this method, this stack will
    # be executed after the event specific stack is executed and didn't
    # stop execution
    def bind_all(object, method)
      bind :all, object, method
    end

    # remove the *method* from executing after every event,
    # only if you registered this method with #bind_all,
    #
    # this won't remove the method if it was registered with #bind
    def unbind_all(object, method)
      unbind :all, object, method
    end

    # execute *event* stack of methods in Last-In-First-Out,
    # then execute methods registered
    # to be executed after all events with #bind_all method
    # if any method in this chain returned false, it will stop the rest
    # of the stack.
    #
    # a chained event is an event that contain a space
    # between 2 or more events lie "\C-c \C-x" so this event
    # should be executed when these 2 events occure after
    # each other,
    # if you tried to trigger the first part \C-c the
    # trigger method will return CHAINED, assuming that \C-c
    # is not handled and also if handled the handle execution
    # didn't return false to interrupt the execution
    def trigger(event)
      return INTERRUPTED unless trigger_for_event(event, event) &&
                                trigger_for_event(:all, event)
      return CHAINED if chained?(event)
      CONTINUE
    end

    # class will have the same methods as the EventManager
    # instance, so you can attack events and trigger it globally
    # like if you have a global instance if EventManager and
    # you're attaching and triggering events from it instead
    # if talking to a specific instance, this global trigger
    # will be handled by one of the editor toplevel components
    # and it should be the lowest priority, if every thing else
    # can't handle the event it should ask this class if anyone
    # registered something globally to handle this event.
    #
    # if you want to handle events in your major mode, minor modes
    # or anything that the application will ask it to trigger event
    # you need to instanciate an object, if you need your action to
    # the default and should be handled globally, like exiting the application
    # or changing theme, or changing some global variable, update packages
    # or any similar global actions, then using the class methods will
    # make sense here.
    class << self
      extend Forwardable

      def_delegators :instance, :bind, :unbind, :bind_all, :unbind_all, :trigger

      # trigger an array of event_managers with an event
      # and return one of the 3 statuses (INTERRUPTED, CHAINED, CONTINUE)
      #
      # if any manager returned false or INTERRUPTED will
      # not execute further and return INTERRUPTED,
      #
      # if it faced an event that wants to chain the event
      # it will return CHAINED if all next managers returned
      # CONTINUE or also CHAINED
      #
      # will return CONTINUE if all manangers returned continue
      #
      # event(Symbol):: an event to trigger on all provided managers
      # *event_managers(*Array):: you can pass as many event managers as
      # you like as parameters to this method, it will be triggered in order
      def join(event, *event_managers)
        event_managers.inject(CONTINUE) do |result, manager|
          case manager.trigger(event)
          when INTERRUPTED, false
            break INTERRUPTED
          when CHAINED
            CHAINED
          else
            result
          end
        end
      end

      private

      def instance
        @instance ||= new
      end
    end

    private

    def trigger_for_event(stack, event)
      @bindings[stack].all? do |binding|
        binding[:object].send binding[:method], event
      end
    end

    def update_chains
      @chains = Set.new
      @bindings.each do |event|
        add_chain(event)
      end
    end

    def add_chain(event)
      event = event.to_s.strip
      return unless event.include?(' ')
      event.split(" ").inject("") do |chain, evt|
        new_chain = (chain + " " + evt).strip
        @chains << new_chain
        new_chain
      end
    end

    def chained?(event)
      @chains.include? event
    end
  end
end
