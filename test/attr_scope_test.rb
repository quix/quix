require File.dirname(__FILE__) + "/common"

require "quix/attr_scope"

class TestAttrScope < Test::Unit::TestCase
  include Quix::AttrScope

  class A
    attr_accessor :x, :y
  end

  def test_attr_scope
    a = A.new
    a.x = 33
    a.y = 44
    count = 0
    
    assert_equal 33, a.x
    assert_equal 44, a.y
    attr_scope(a, :x => 55, :y => 66) {
      count += 1
      assert_equal 55, a.x
      assert_equal 66, a.y
    }
    assert_equal 1, count
    assert_equal 33, a.x
    assert_equal 44, a.y

    assert_raises(ArgumentError) {
      attr_scope(a) { }
    }
    assert_raises(ArgumentError) {
      attr_scope(a)
    }
    assert_raises(ArgumentError) {
      attr_scope(a, 1, 2)
    }
    assert_raises(ArgumentError) {
      attr_scope
    }
  end
end
