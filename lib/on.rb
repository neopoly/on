require 'on/version'
require 'set'

class On
  def initialize(*callbacks, &block)
    raise ArgumentError, "please provide at least one callback" if callbacks.empty?
    raise ArgumentError, "please provide a block" unless block
    @callbacks  = Set.new(callbacks)
    @block      = block
  end

  def call(name, *args)
    validate_callback!(name)
    @callback = Callback.new(name, args)
    @block.call(self)
  end

  def on(name, &block)
    validate_callback!(name)
    if @callback && @callback.name == name
      block.call(*@callback.args)
    end
  end

  Callback = Struct.new(:name, :args)

  class InvalidCallback < StandardError
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
