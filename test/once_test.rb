require File.dirname(__FILE__) + '/quix_test_base'

require 'quix/once'

class TestOnce < Test::Unit::TestCase
  include Quix::Once

  def f
    rand
  end

  def g
    once { rand }
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
      eval("once { rand }")
    }
  end
end

