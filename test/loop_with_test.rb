require File.dirname(__FILE__) + "/common"

require "quix/loop_with"

class TestLoopWith < Test::Unit::TestCase
  include Quix::LoopWith

  def test_loop_with_1
    memo = Array.new
    result = loop_with(:leave, :again) {
      memo.push :data
      if memo.size < 3
        throw :again
      else
        throw :leave, 33
        assert false
      end
    }
    assert_equal 33, result
    assert_equal((1..3).map { :data }, memo)
  end

  def test_loop_with_2
    memo = Array.new
    result = loop_with(:leave) {
      memo.push :data
      throw :leave, 33
    }
    assert_equal 33, result
    assert_equal((1..1).map { :data }, memo)
  end

  def test_loop_with_3
    memo = Array.new
    loop_with(nil, :again) {
      memo.push :data
      if memo.size < 3
        throw :again
      else
        break
      end
    }
    assert_equal((1..3).map { :data }, memo)
  end

  def test_loop_with_4
    memo = Array.new
    loop_with {
      memo.push :data
      if memo.size >= 3
        break
      end
    }
    assert_equal((1..3).map { :data }, memo)
  end
end
