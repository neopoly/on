require 'helper'

require 'on'

class IntegrationTest < Spec
  def tweet(message, &block)
    callback = On.new(:success, :failure, &block)
    case message
    when NilClass
      callback.call :failure, "blank"
    when /^Sir,.*/
      callback.call :success, message
    end
  end

  test "it calls success" do
    tweet "Sir, hello world", &recorder
    assert_callback recorder, :success, "Sir, hello world"
  end

  test "it calls failure" do
    tweet nil, &recorder
    assert_callback recorder, :failure, "blank"
  end

  test "no callback called" do
    tweet "you're such a fool", &recorder
    refute_callbacks recorder
    refute recorder.block_called?
  end

  test "invalid callback name" do
    e = assert_raises On::InvalidCallback do
      tweet "Sir, hi" do |callback|
        recorder.record_block
        callback.on(:invalid) {}
      end
    end
    assert_equal "Invalid callback :invalid", e.message
    assert recorder.block_called?
    refute_callbacks recorder
  end
end
