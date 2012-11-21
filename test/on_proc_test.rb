require 'helper'

require 'on/proc'

class OnProcTest < Testem
  def oddeven(number, &block)
    callback = block.on(:odd, :even)
    if number % 2 == 0
      callback.call :even
    else
      callback.call :odd
    end
  end

  def verify(number)
    oddeven(number) do |callback|
      called! :block, number
      callback.on :odd do
        called! :odd
      end
      callback.on :even do
        called! :even
      end
    end
  end

  let(:called) { [] }

  before do
    called.clear
  end

  test "call proc" do
    verify(1)
    verify(2)

    assert_called [ :block, 1 ], [ :odd ], [ :block, 2 ], [ :even ]
  end

  private

  def assert_called(*args)
    assert_equal called, args
  end

  def called!(*args)
    called << args
  end
end
