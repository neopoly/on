if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'minitest/autorun'

require 'on'
require 'on/test_helper'

class Spec < Minitest::Spec
  include On::TestHelper

  class << self
    alias test it
    alias context describe
  end

  let(:recorder) { On::TestHelper::Recorder.new }
end
