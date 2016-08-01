require 'helper'

require 'on/proc'

class OnProcTest < Spec
  def oddeven(number, &block)
    callback = block.on(:odd, :even)
    if number % 2 == 0
      callback.call :even
    else
      callback.call :odd
    end
  end

  test "call proc" do
    oddeven(1, &recorder)
    assert_callback recorder, :odd

    oddeven(2, &recorder)
    assert_callback recorder, :even
  end
end
