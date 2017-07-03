require 'on'

# Syntatic sugar for defining a callback class.
#
# = Example
#
#   require 'on/class'
# 
#   class Bird
#     Callback = On::Class.build(:success, :failure)
#
#     def tweet(message, &block)
#       callback = Callback.new(&block)
#       callback.call :success
#     rescue => e
#       callback.call :failure, e.message
#     end
#   end
# 
#   bird = Bird.new
#   bird.tweet "hello world" do |callback|
#     callback.on :success do
#       # handle success
#     end
#     callback.on :failure do |error_message|
#       # handle error message
#     end
#   end
class On
  class Class
    def self.build(*callbacks)
      new(*callbacks).to_class
    end

    def initialize(*callbacks)
      @callbacks = callbacks
    end

    def to_class
      cls = ::Class.new(CallbackClass)
      cls.callbacks = @callbacks

      cls
    end

    class CallbackClass
      class << self
        attr_accessor :callbacks
      end

      def initialize(&block)
        @on = On.new(*self.class.callbacks, &block)
      end

      def call(callback, *args)
        @on.call callback, *args
      end
    end
  end
end
