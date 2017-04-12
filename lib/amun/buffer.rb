require 'set'
require 'amun/object'
require 'amun/event_manager'
require 'amun/major_modes/fundamental'
require 'forwardable'

module Amun
  # A buffer could present any kind of IO object (File, StringIO...etc)
  # also it has a major mode responsible update lines and visual lines
  class Buffer < Object
    extend Forwardable
    attr_accessor :name, :io, :major_mode, :minor_modes

    def initialize(name, io = StringIO.new)
      super()
      self.io = io
      self.name = name
      self.point = 0
      self.text = ''
      self.major_mode = MajorModes::Fundamental.new(self)
      self.minor_modes = Set.new
    end

    attr_writer :point
    def point
      return 0 if @point < 0
      return length if @point > length
      @point
    end

    attr_writer :mark
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

    # buffer should wrap the inner @text
    # and expose any reading method but
    # control the writing methods

    def_delegators :text,
                   :length, :size, :[],
                   :count, :index, :rindex,
                   :empty?

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

    def to_s
      text.dup
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
