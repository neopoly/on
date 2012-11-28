require 'helper'

require 'on'

class IntegrationTest < Testem
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
    tweet "Sir, hello world" do |callback|
      called! :method
      callback.on :success do |message|
        called! :success, message
      end
      callback.on :failure do |message|
        called! :failure, message
      end
    end

    assert_called [ :method ], [ :success, "Sir, hello world" ]
  end

  test "it calls failure" do
    tweet nil do |callback|
      called! :method
      callback.on :success do |message|
        called! :success, message
      end
      callback.on :failure do |message|
        called! :failure, message
      end
    end

    assert_called [ :method ], [ :failure, "blank" ]
  end

  test "no callback called" do
    tweet "you're such a fool" do |callback|
      called! :method
    end

    assert_called
  end

  test "invalid callback name" do
    e = assert_raises On::InvalidCallback do
      tweet "Sir, hi" do |callback|
        called! :method

        callback.on :invalid do
          called! :invalid
        end
      end
    end
    assert_equal "Invalid callback :invalid", e.message

    assert_called [:method]
  end
end
