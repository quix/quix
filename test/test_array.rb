require File.dirname(__FILE__) + "/common"

require "quix/ext/array"

class TestArray < Test::Unit::TestCase
  def test_array
    a = [3, 4, 5]
    assert_equal a.first, a.head
    assert_equal [4, 5], a.tail

    t = %w[a b c d e f g h i j].map { |t| t.to_sym }
    assert_equal :a, t.first
    assert_equal :b, t.second
    assert_equal :c, t.third
    assert_equal :d, t.fourth
    assert_equal :e, t.fifth
    assert_equal :f, t.sixth
    assert_equal :g, t.seventh
    assert_equal :h, t.eighth
    assert_equal :i, t.ninth
    assert_equal :j, t.tenth
  end
end
