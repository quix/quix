require File.dirname(__FILE__) + '/quix_test_base'

require 'quix/attr_lazy'

class TestAttrLazy < Test::Unit::TestCase
  def test_1_reader
    n = 0
    cls = Class.new do
      include Quix::AttrLazy
      attr_lazy :f do
        n += 1
        33
      end
    end
    s = cls.new
    
    3.times { assert_equal(33, s.f) }
    assert_equal(1, n)

    s.attr_lazy :f do 
      77
    end
    assert_equal(77, s.f)

    assert_raises(NoMethodError) {
      s.f = 99
    }
  end
    
  def test_1_accessor
    n = 0
    cls = Class.new do
      include Quix::AttrLazy
      attr_lazy_accessor :f do
        n += 1
        33
      end
    end
    s = cls.new
    
    3.times { assert_equal(33, s.f) }
    assert_equal(1, n)

    s.attr_lazy :f do 
      77
    end
    assert_equal(77, s.f)

    s.f = 99
    assert_equal(99, s.f)
  end
    
  def test_2
    cls = Class.new do
      include Quix::AttrLazy

      attr_lazy :x do
        33
      end
      
      attr_lazy :y do
        44
      end
      
      attr_lazy_accessor :z do
        x + y
      end
    end
    
    assert_equal(33 + 44, cls.new.z)
    a = cls.new
    a.z = 99
    assert_equal(99, a.z)
  end

  def test_3
    cls = Class.new do
      include Quix::AttrLazy

      attr_lazy :f do
        @u = 99
        55
      end

      attr_reader :u
    end

    a = cls.new
    assert_equal nil, a.u
    assert_equal 55, a.f
    assert_equal 99, a.u

    a.attr_lazy_accessor :f do
      77
    end
    assert_equal 77, a.f

    a.f = 88
    assert_equal 88, a.f
  end

  def test_4
    cls = Class.new do
      include Quix::AttrLazy
      attr_lazy :x do
        33
      end
    end

    a = cls.new
    class << a
      attr_lazy :x do
        99
      end
    end
    
    assert_equal(99, a.x)
  end

  def test_5
    cls = Class.new do
      include Quix::AttrLazy
      attr_lazy :x do
        33
      end
    end

    a = cls.new
    b = cls.new

    a.attr_lazy :x do
      44
    end
    assert_equal 44, a.x
    assert_equal 33, b.x
  end

  class A
    include Quix::AttrLazy
    def initialize(x)
      attr_lazy :x do
        x
      end
    end
  end

  def test_6
    assert_equal 99, A.new(99).x
  end
end

