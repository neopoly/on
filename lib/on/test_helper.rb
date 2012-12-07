class On
  # Helper for testing On callbacks.
  #
  # == Example
  #
  #   require 'minitest/autorun'
  #   require 'on'
  #   require 'on/test_helper'
  #
  #   class SomeTest < MiniTest::Spec
  #     include On::TestHelper
  #
  #     let(:recorder) { On::TestHelper::Recorder.new }
  #
  #     it "records everything" do
  #       on = On.new(:success, :failure, &recorder)
  #       on.call :success, :some, :args
  #       assert_callback recorder, :success, :some, :args
  #     end
  #
  #     it "calls nothing" do
  #       on = On.new(:success, :failure, &recorder)
  #       # nothing called
  #       refute_callbacks recorder
  #     end
  #
  #     it "records everything manually" do
  #       on = On.new(:success, :failure) do |result|
  #         recorder.record_block
  #         recorder.record_callback(result, :success, :failure)
  #       end
  #       on.call :success, :some, :args
  #       assert_callback recorder, :success, :some, :args
  #     end
  #
  #     it "checks record args in a block" do
  #       on = On.new(:success, :failure) do |result|
  #         recorder.record_block
  #         recorder.record_callback(result, :success, :failure)
  #       end
  #       on.call :success, :some, :args
  #       assert_callback recorder, :success do |some, args|
  #         assert_equal :some, some
  #         assert_equal :args, args
  #       end
  #     end
  #   end
  module TestHelper
    # Asserts that a certain callbacks has been recorded by +recorder+.
    #
    # == Example
    #
    #   assert_callback recorder, :success, "some", "args"
    #
    def assert_callback(recorder, name, *args)
      raise ArgumentError, "Provide args or block but not both" if block_given? && !args.empty?

      callback = recorder.last_record
      assert callback, "No callbacks found"
      assert_equal name, callback.name, "Callback was #{callback}"
      if block_given?
        yield *callback.args
      else
        assert_equal args, callback.args, "Callback was #{callback}"
      end
    end

    # Asserts that *no* callbacks has been recorder by +recorder+.
    def refute_callbacks(recorder)
      assert recorder.empty?, "Something has been recorded #{recorder.inspect}"
    end

    # Record callbacks.
    class Recorder
      Callback = Struct.new(:name, :args)

      def initialize
        @block      = false
        @callbacks  = []
      end

      def block_called?
        @block
      end

      def empty?
        @callbacks.empty?
      end

      # Pops the last recorded recorded.
      def last_record
        @callbacks.pop
      end

      # Records block and all defined callbacks.
      def record_all
        proc do |on|
          record_block
          record_callback(on, *on.callbacks)
        end
      end

      # Records a block.
      #
      #   recorder = Recorder.new
      #   On.new(:success) do |callback|
      #     recorder.record_block
      #     callback.on :success do
      #       # assert...
      #     end
      #   end
      #
      #   assert recorder.block_called?
      def record_block
        @block = true
      end

      # Records a single callback.
      def record_callback(on, *names)
        names.each do |name|
          on.on name do |*args|
            callback_recorded(name, args)
          end
        end
      end

      def callback_recorded(name, args)
        @callbacks << Callback.new(name, args)
      end

      # Short-hand for &+recorder.record_all+.
      def to_proc
        record_all
      end
    end
  end
end
