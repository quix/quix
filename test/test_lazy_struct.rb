require File.dirname(__FILE__) + "/common"

require 'quix/lazy_struct'

class TestLazyStruct < Test::Unit::TestCase
  def common(s)
    s.f = 33
    assert_equal(33, s.f)

    n = 0
    s.attribute(:f) {
      n += 1
      44
    }
    
    3.times {
      assert_equal(44, s.f)
    }
    assert_equal(1, n)

    s.f = 77
    assert_equal 77, s.f
  end

  def test_lazy_struct_1
    common(Quix::LazyStruct.new)
  end

  def test_lazy_struct_2
    s = OpenStruct.new
    class << s
      include Quix::LazyStruct::Mixin
    end
    common(s)
  end
end

