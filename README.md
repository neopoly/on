# On

[<img src="https://secure.travis-ci.org/neopoly/on.png?branch=master"
alt="Build Status" />](http://travis-ci.org/neopoly/on) [<img
src="https://badge.fury.io/rb/on.png" alt="Gem Version"
/>](http://badge.fury.io/rb/on) [<img
src="https://codeclimate.com/github/neopoly/on.png"
/>](https://codeclimate.com/github/neopoly/on) [<img
src="http://inch-ci.org/github/neopoly/on.png"
/>](http://inch-ci.org/github/neopoly/on)

Dynamic callbacks for Ruby blocks.

[Gem](https://rubygems.org/gems/on) | [Source](https://github.com/neopoly/on)
|
[Documentation](http://rubydoc.info/github/neopoly/on/master/file/README.rdoc)

Inspired by
http://www.mattsears.com/articles/2011/11/27/ruby-blocks-as-dynamic-callbacks

## Usage

Basic usage.

```ruby
require 'on'

def tweet(message, &block)
  callback = On.new(:success, :failure, &block)
  callback.call :success
rescue => e
  callback.call :failure, e.message
end

tweet "hello world" do |callback|
  callback.on :success do
    # handle success
  end
  callback.on :failure do |error_message|
    # handle error message
  end
end
```

## Usage with proc

Syntatic sugar for creating an `on` callback from Proc.

```ruby
require 'on/proc'

def tweet(message, &block)
  callback = block.on(:success, :failure)
  callback.call :success
rescue => e
  callback.call :failure, e.message
end

tweet "hello world" do |callback|
  callback.on :success do
    # handle success
  end
  callback.on :failure do |error_message|
    # handle error message
  end
end
```

## Testing with On::TestHelper

```ruby
require 'minitest/autorun'
require 'on'
require 'on/test_helper'

class SomeTest < MiniTest::Spec
  include On::TestHelper

  let(:recorder) { On::TestHelper::Recorder.new }

  it "records everything" do
    on = On.new(:success, :failure, &recorder)
    on.call :success, :some, :args
    assert_callback recorder, :success, :some, :args
  end

  it "calls nothing" do
    on = On.new(:success, :failure, &recorder)
    # nothing called
    refute_callbacks recorder
  end

  it "records everything manually" do
    on = On.new(:success, :failure) do |result|
      recorder.record_block
      recorder.record_callback(result, :success, :failure)
    end
    on.call :success, :some, :args
    assert_callback recorder, :success, :some, :args
  end
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'on'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install on
```

## Contributing

1.  Fork it
2.  Create your feature branch (`git checkout -b my-new-feature`)
3.  Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5.  Create new Pull Request

