require File.dirname(__FILE__) + "/common"

require 'quix/lazy_attribute'
require 'ostruct'

class TestLazyAttribute < Test::Unit::TestCase
  class Stuff
    include Quix::LazyAttribute
  end

  def common(s)
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

  def test_1
    common(Stuff.new)
  end

  def test_2
    s = OpenStruct.new
    class << s
      include Quix::LazyAttribute
    end
    common(s)
  end
end

