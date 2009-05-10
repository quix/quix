require File.dirname(__FILE__) + "/common"

require 'quix/thread_local'

class TestThreadLocal < Test::Unit::TestCase
  def test_unique
    a = Quix::ThreadLocal.new { Hash.new }
    a.value[:x] = 33
    other_value = nil
    Thread.new {
      a.value[:x] = 44
      other_value = a.value[:x]
    }.join
    assert_equal(33, a.value[:x])
    assert_equal(44, other_value)

    a.clear { 55 }
    assert_equal 55, a.value
  end
  
  class A
    include Quix::ThreadLocal.accessor_module(:x) { 33 }
  end

  class B
    include Quix::ThreadLocal.reader_module(:x) { 33 }
  end

  def test_accessor
    a = A.new
    assert_equal(33, a.x)
    a.x = 44
    assert_equal(44, a.x)
  end

  def test_reader
    b = B.new
    assert_equal(33, b.x)
  end
end

