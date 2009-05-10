require File.dirname(__FILE__) + "/common"

require "quix/ext/array"

class TestArray < Test::Unit::TestCase
  def test_array
    a = [3, 4, 5]
    assert_equal a.first, a.head
    assert_equal [4, 5], a.tail
  end
end
