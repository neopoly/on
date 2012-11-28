require 'minitest/autorun'
require 'testem'

class Testem
  let(:called) { [] }

  setup do
    called.clear
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
