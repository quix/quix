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
  end
  
  class A
    include Quix::ThreadLocal.accessor_module(:x) { 33 }
  end

  def test_accessor
    a = A.new
    assert_equal(33, a.x)
    a.x = 44
    assert_equal(44, a.x)
  end
end

