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
  def initialize(*callbacks, &block)
    raise ArgumentError, "please provide at least one callback" if callbacks.empty?
    raise ArgumentError, "please provide a block" unless block
    @callbacks  = Set.new(callbacks)
    @block      = block
  end

  # Dispatch callback.
  def call(name, *args)
    validate_callback_name!(name)
    record_callback(name, args)
    call_block
  end

  # Handle a callback.
  def on(name, &block)
    validate_callback_name!(name)
    handle_callback(name, block)
  end

  Callback = Struct.new(:name, :args)

  class InvalidCallback < StandardError # :nodoc:
    def initialize(name)
      super("Invalid callback #{name.inspect}")
    end
  end

  private

  def validate_callback_name!(name)
    unless @callbacks.include?(name)
      raise InvalidCallback, name
    end
  end

  def record_callback(name, args)
    @callback = Callback.new(name, args)
  end

  def call_block
    @block.call(self)
  end

  def handle_callback(name, block)
    if @callback && @callback.name == name
      block.call(*@callback.args)
    end
  end
end
