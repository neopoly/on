require 'minitest/autorun'
require 'testem'

require 'on/test_helper'

class Testem
  include On::TestHelper

  let(:recorder) { On::TestHelper::Recorder.new }
end
