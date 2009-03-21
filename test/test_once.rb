$LOAD_PATH.unshift File.dirname(__FILE__) + "/../lib"

require 'test/unit'
require 'quix/this_line_once'

class TestOnce < Test::Unit::TestCase
  include Quix::ThisLineOnce

  def f
    rand
  end

  def g
    this_line_once { rand }
  end

  def test_once
    assert_not_equal(f, f)
    assert_not_equal(f, f)

    x = g
    y = g
    z = g
    assert_equal(x, y)
    assert_equal(x, z)

    assert_raises(RuntimeError) {
      eval("this_line_once { }")
    }
  end
end

