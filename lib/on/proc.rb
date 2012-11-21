# Syntatic sugar for creating an +on+ callback from Proc.
#
# = Example
#
#   require 'on/proc'
# 
#   def tweet(message, &block)
#     callback = block.on(:success, :failure)
#     callback.call :success
#   rescue => e
#     callback.call :failure, e.message
#   end
# 
#   tweet "hello world" do |callback|
#     callback.on :success do
#       # handle success
#     end
#     callback.on :failure do |error_message|
#       # handle error message
#     end
#   end
class Proc
  def on(*callbacks)
    On.new(*callbacks, &self)
  end
end
