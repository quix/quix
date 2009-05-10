require File.dirname(__FILE__) + "/common"

require "quix/attr_scope"

class TestAttrScope < Test::Unit::TestCase
  include Quix::AttrScope

  class A
    attr_accessor :x
  end

  def test_loop_with
    a = A.new
    a.x = 33
    
    assert_equal 33, a.x
    attr_scope(a, :x, 44) {
      assert_equal 44, a.x
    }
    assert_equal 33, a.x
  end
end
