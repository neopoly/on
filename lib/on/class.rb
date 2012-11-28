require 'on'

class On
  module Class
    def to_proc
      proc do |on|
        callback = on.callback
        send("on_#{callback.name}", *callback.args)
      end
    end
  end
end

class Tester
  include On::Class

  def on_start
    p :start
  end

  def on_end(r)
    p :end => r
  end
end

def foo(var, &block)
  callback = On.new(:start, :end, &block)
  if var
    callback.call :start
  else
    callback.call :end, :foo
  end
end

tester = Tester.new

foo(true, &tester)
foo(false, &tester)
