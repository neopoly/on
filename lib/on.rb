require 'on/version'
require 'set'

# Dynamic callbacks for Ruby blocks.
#
# = Example
#
#  require 'on'
#
#  def tweet(message, &block)
#    callback = On.new(:success, :failure, &block)
#    callback.call :success
#  rescue => e
#    callback.call :failure, e.message
#  end
#
#  tweet "hello world" do |callback|
#    callback.on :success do
#      # handle success
#    end
#    callback.on :failure do |error_message|
#      # handle error message
#    end
#  end
class On
  # Returns the Callback called or +nil+ if none called.
  attr_reader :callback

  def initialize(*callbacks, &block)
    raise ArgumentError, "please provide at least one callback" if callbacks.empty?
    raise ArgumentError, "please provide a block" unless block
    @callbacks  = Set.new(callbacks)
    @callback   = nil
    @block      = block
  end

  # Dispatch callback.
  def call(name, *args)
    validate_callback!(name)
    @callback = Callback.new(name, args)
    @block.call(self)
  end

  # Handle a callback.
  def on(name, &block)
    validate_callback!(name)
    if @callback && @callback.name == name
      block.call(*callback.args)
    end
  end

  # Returns a list of supported callback names provided in the initializer.
  def callbacks
    @callbacks.to_a
  end

  # Represents a callback called with its +name+ and +args+.
  class Callback < Struct.new(:name, :args)
  end

  class InvalidCallback < StandardError # :nodoc:
    def initialize(name)
      super("Invalid callback #{name.inspect}")
    end
  end

  private

  def validate_callback!(name)
    unless @callbacks.include?(name)
      raise InvalidCallback, name
    end
  end
end
