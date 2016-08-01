require 'helper'

require 'on'

class OnTest < Spec
  context "initialize" do
    test "at least one callback" do
      e = assert_raises ArgumentError do
        On.new
      end
      assert_equal "please provide at least one callback", e.message
    end

    test "block missing" do
      e = assert_raises ArgumentError do
        On.new :success
      end
      assert_equal "please provide a block", e.message
    end
  end

  context "with an instance" do
    test "returns a list of supported callback names" do
      on = On.new(:success, :failure) {}
      assert_equal 2, on.callbacks.size
      assert on.callbacks.include?(:success)
      assert on.callbacks.include?(:failure)
    end

    test "calls callback w/o args" do
      on = On.new(:success, &recorder)
      on.call :success

      assert recorder.block_called?
      assert_callback recorder, :success
    end

    test "calls callback with args" do
      on = On.new(:success, &recorder)
      on.call :success, :foo, :bar

      assert recorder.block_called?
      assert_callback recorder, :success, :foo, :bar

      assert on.callback
      assert_equal :success, on.callback.name
    end

    test "calls invalid callback" do
      on = On.new(:correct) {}
      e = assert_raises On::InvalidCallback do
        on.call :wrong
      end

      assert_equal "Invalid callback :wrong", e.message
    end

    test "handles invalid callback" do
      on = On.new(:correct) do |callback|
        callback.on :wrong
      end
      e = assert_raises On::InvalidCallback do
        on.call :correct
      end
      assert_equal "Invalid callback :wrong", e.message
    end

    test "does not explode when nothing called" do
      on = On.new(:something, &recorder)

      refute_callbacks recorder
      refute recorder.block_called?

      assert_nil on.callback
    end
  end
end
