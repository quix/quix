require File.dirname(__FILE__) + "/common"

require "quix/ext/enumerable"

class TestEnumerable < Test::Unit::TestCase
  def test_group_consecutive_by
    data = [3, 4, 5, 5, 6, 5, 5, 4, 4, 4, 4, 3, 3, 2, 1]
    grouped = [[3], [4], [5, 5], [6], [5, 5], [4, 4, 4, 4], [3, 3], [2], [1]]
    
    assert_equal grouped, data.group_consecutive_by { |t| t }

    data = (1..6).to_a
    assert_equal data.map { |t| [t] }, data.group_consecutive_by { |t| t }

    expected = [[1, 2, 3], [4, 5, 6]]
    computed = data.group_consecutive_by { |t| t <= 3 }
    assert_equal expected, computed
  end

  def test_build_hash
    data = 3..5
    expected = {
      3 => 9,
      4 => 16,
      5 => 25,
    }
    computed = data.build_hash { |elem|
      [elem, elem**2]
    }
    assert_equal expected, computed
  end

  def test_take_drop
    data = 3..8
    
    assert_equal [6, 7, 8], data.drop_while { |t| t < 6 }
    assert_equal [6, 7, 8], data.drop_until { |t| t == 6 }
    
    assert_equal [3, 4, 5], data.take_while { |t| t < 6 }
    assert_equal [3, 4, 5], data.take_until { |t| t == 6 }

    assert_equal data.to_a, data.take_while { true }
    assert_equal data.to_a, data.take_until { |t| t == 999 }
    assert_equal [], data.drop_while { true }
    assert_equal [], data.drop_until { |t| t == 999 }
  end
end
