require 'minitest/autorun'
require 'testem'
require 'simple_assertions'

require 'on'

class Testem
  include SimpleAssertions::AssertRaises
end
