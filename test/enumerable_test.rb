require File.dirname(__FILE__) + '/quix_test_base'

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

  def test_build_hash_1
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

  def test_build_hash_2
    data = 3..5
    expected = {
      3 => 9,
      5 => 25
    }
    computed = data.build_hash { |elem|
      if elem == 4
        nil
      else
        [elem, elem**2]
      end
    }
    assert_equal expected, computed
  end

  def test_build_hash_3
    actual = [:x, :y].build_hash(:z => 55) { |e| [e, 33] }
    expected = {
      :x => 33,
      :y => 33,
      :z => 55,
    }
    assert_equal expected, actual
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

  def test_map_select
    assert_equal [9, 16, 25], [3, 4, 5].map_select { |x| x**2 }
    assert_equal %w[a c], %w[a b c d].map_select { |s| s[%r!\A(a|c)\Z!, 1] }
    assert_equal [], (3..8).to_a.map_select { nil }
    assert_equal [9, 16, 25], (3..8).map_select { |e| e < 6 ? e**2 : nil }
  end
end
