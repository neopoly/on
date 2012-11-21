require 'minitest/autorun'
require 'testem'

class On
  def initialize *callbacks
    @callbacks = callbacks
  end

  def callback(*args)
    @current = args
    self
  end

  def method_missing method, *args, &block
    if @callbacks.empty? || @callbacks.include?(method)
      if @current[0] == method
        yield *@current[1]
      end
    else
      super
    end
  end
end

def tweet(ok, &block)
  block.callbacks :success, :failure
  if ok
    block.callback :success, 23
  else
    block.callback :failure, 25
  end
end

class Proc
  def callbacks(*names)
    @on = On.new(*names)
  end

  def callback(*args)
    @on ||= On.new
    call @on.callback(*args)
  end
end

tweet([true, false].sample) do |on|
  on.success do |number|
    p :success => number
  end
  on.failure do |number|
    p :fail => number
  end
end
