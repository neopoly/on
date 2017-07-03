require 'helper'

require 'on/class'

class OnClassTest < Testem
  Callback = On::Class.build(:odd, :even)

  def oddeven(number, &block)
    callback = Callback.new(&block)
    if number % 2 == 0
      callback.call :even
    else
      callback.call :odd
    end
  end

  test "call class" do
    oddeven(1, &recorder)
    assert_callback recorder, :odd

    oddeven(2, &recorder)
    assert_callback recorder, :even
  end
end
