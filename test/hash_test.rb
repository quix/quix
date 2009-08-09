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
    s.each_pair_sort_keys { |key, value|
      memo << key
    }
    assert_equal %w[x y z], memo

    memo = Array.new
    s.each_pair_sort_values { |key, value|
      memo << key
    }
    assert_equal %w[y x z], memo
  end

  def test_hash_of_array
    h = Hash.of Array
    assert h.empty?
    assert h[:x].is_a?(Array)
    assert_block { not h.empty? }
    h[:x] << 33
    assert_equal [33], h[:x]
  end

  def test_hash_of_hashes
    h = Hash.of Hash
    assert h.empty?
    assert h[:x].is_a?(Hash)
    assert_block { not h.empty? }
    h[:x][:y] = 33
    assert_equal 33, h[:x][:y]
  end

  def test_nonempty
    assert_equal false, {}.nonempty?
    assert_equal true,  {3 => 4}.nonempty?
    assert_equal true,  {3 => 4, 5 => 6}.nonempty?
  end
end
