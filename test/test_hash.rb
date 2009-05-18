require File.dirname(__FILE__) + "/common"

require "quix/ext/hash"

class TestHash < Test::Unit::TestCase
  def test_hash
    s = {
      "z" => 99,
      "x" => 88,
      "y" => 77,
    }

    memo = Array.new
    s.key_sorted_each_pair { |key, value|
      memo << key
    }
    assert_equal %w[x y z], memo

    memo = Array.new
    s.value_sorted_each_pair { |key, value|
      memo << key
    }
    assert_equal %w[y x z], memo
  end
end
