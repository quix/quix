require File.dirname(__FILE__) + "/common"

require "quix/stack"

class TestStack < Test::Unit::TestCase
  def test_stack
    s = Quix::Stack.new
    assert s.empty?
    s.push :a
    assert_equal false, s.empty?
    assert_equal :a, s.top
    s.push :b
    assert_equal :b, s.top
    s.push :c
    assert_equal :c, s.pop
    assert_equal :b, s.top
    assert_equal :b, s.pop
    assert_equal :a, s.pop
    assert_nil s.top
    assert_nil s.pop
    assert_nil s.top
  end
end
