require 'helper'

require 'on'

class OnTestHelperTest < Testem
  context "assert_callback" do
    test "match w/o args" do
      record :foo
      assert_callback recorder, :foo
    end

    test "evaluates assertion messages lazily" do
      record_boom :foo
      assert_callback recorder, :foo
    end

    test "match with args" do
      record :foo, :bar, :baz
      assert_callback recorder, :foo, :bar, :baz
    end

    test "match with block" do
      called = false
      record :foo, :bar, :baz
      assert_callback recorder, :foo do |bar, baz|
        called = true
        assert_equal :bar, bar
        assert_equal :baz, baz
      end
      assert called
    end

    test "no callbacks found" do
      e = assert_raises MiniTest::Assertion do
        assert_callback recorder, :foo
      end
      assert_equal "No callbacks found", e.message
    end

    test "no callbacks found anymore" do
      record :foo
      assert_callback recorder, :foo
      e = assert_raises MiniTest::Assertion do
        assert_callback recorder, :foo
      end
      assert_equal "No callbacks found", e.message
    end

    test "mismatch name" do
      record :foo

      e = assert_raises MiniTest::Assertion do
        assert_callback recorder, :bar
      end
      assert_match /Expected: :bar\n\s*Actual: :foo/, e.message
    end

    test "mismatch args" do
      record :foo, :bar
      e = assert_raises MiniTest::Assertion do
        assert_callback recorder, :foo, :baz
      end
      assert_match /Expected: \[:baz\]\n\s*Actual: \[:bar\]/, e.message
    end

    test "mismatch block" do
      called = false
      record :foo, :bar
      e = assert_raises MiniTest::Assertion do
        assert_callback recorder, :foo do |bar|
          called = true
          assert_equal :baz, bar
        end
      end
      assert_match /Expected: :baz\n\s*Actual: :bar/, e.message
      assert called
    end

    test "fail on args and block" do
      called = false
      e = assert_raises ArgumentError do
        assert_callback recorder, :foo, :bar do
          called = true
        end
      end
      assert_equal "Provide args or block but not both", e.message
      refute called
    end
  end

  context "refute_callbacks" do
    test "nothing recorded" do
      refute_callbacks recorder
    end

    test "fail when something recorded" do
      record :foo
      e = assert_raises MiniTest::Assertion do
        refute_callbacks recorder
      end
      assert_match /Something has been recorded/, e.message
    end
  end

  private

  class BoomCallback < On::TestHelper::Recorder::Callback
    def to_s
      raise "I should NOT be called"
    end
  end

  def record_boom(name, *args)
    callback = BoomCallback.new(name, args)
    recorder.callback_recorded(callback)
  end

  def record(name, *args)
    recorder.callback_recorded(name, args)
  end
end
