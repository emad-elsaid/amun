require 'set'
require 'amun/event_manager'
require 'amun/major_modes/fundamental'
require 'forwardable'

module Amun
  # A buffer could present any kind of IO object (File, StringIO...etc)
  # also it has a major mode responsible update lines and visual lines
  class Buffer
    extend Forwardable
    def_delegators :text,
                   :length, :size, :[],
                   :count, :index, :rindex,
                   :to_s, :empty?

    attr_accessor :name, :io
    attr_writer :major_mode, :events, :minor_modes, :point, :mark

    def initialize(name, io = StringIO.new)
      self.io = io
      self.name = name
      self.point = 0
      self.text = ''
    end

    def events
      @events ||= EventManager.new
    end

    def major_mode
      @major_mode ||= MajorModes::Fundamental.new(self)
    end

    def minor_modes
      @minor_modes ||= Set.new
    end

    def point
      return 0 if @point < 0
      return length if @point > length
      @point
    end

    def mark
      return 0 if @mark < 0
      return length if @mark > length
      @mark
    end

    def trigger(event)
      EventManager.join(
        event,
        *([events] + minor_modes.to_a + [major_mode])
      )
    end

    def insert(index, other_str)
      text.insert(index, other_str)
    end

    def slice!(start, length = 1)
      text.slice!(start, length)
    end

    def <<(p1)
      insert(length, p1)
    end

    def clear
      slice!(0, length)
    end

    class << self
      attr_writer :current, :instances

      def instances
        @instances ||= Set.new
      end

      def current
        @current ||= scratch
      end

      def scratch
        @scratch ||= new('*Scratch*')
        instances << @scratch
        @scratch
      end

      def messages
        @messages ||= new('*Messages*')
        instances << @messages
        @messages
      end
    end

    private

    attr_accessor :text
  end
end
