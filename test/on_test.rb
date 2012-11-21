require 'helper'

class OnTest < Testem
  let(:called) { [] }

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
    before do
      called.clear
    end

    test "calls callback w/o args" do
      on = On.new(:success) do |callback|
        called! :block
        callback.on :success do |*args|
          called! :success, *args
        end
      end
      on.call :success

      assert_called [ :block ], [ :success ]
    end

    test "calls callback with args" do
      on = On.new(:success) do |callback|
        called! :block
        callback.on :success do |*args|
          called! :success, *args
        end
      end
      on.call :success, :foo, :bar

      assert_called [ :block ], [ :success, :foo, :bar ]
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
        called! :block
        callback.on :wrong
      end
      e = assert_raises On::InvalidCallback do
        on.call :correct
      end

      assert_equal "Invalid callback :wrong", e.message
      assert_called [ :block ]
    end

    test "does not explode when nothing called" do
      on = On.new(:something) do
        called! :block
      end
      on.on :something do
        called! :something
      end

      assert_nothing_called
    end
  end

  def called!(*args)
    called << args
  end

  def assert_called(*args)
    assert_equal called, args
  end

  def assert_nothing_called
    assert_called
  end
end
