require File.dirname(__FILE__) + "/common"

require "quix/ext/array"

class TestArray < Test::Unit::TestCase
  def test_head_tail
    a = [3, 4, 5]
    assert_equal 3, a.head
    assert_equal [4, 5], a.tail

    assert_equal 3, [3].head
    assert_equal nil, [].head

    assert_equal nil, [].tail
    assert_equal [], [3].tail
  end
    
  def test_ords
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

    assert_equal :i, t.penultimate
    assert_equal nil, [].penultimate
    assert_equal nil, [:z].penultimate
    assert_equal :y, [:y, :z].penultimate
  end

  def test_split_1
    s = %w[a b c d e f].split("d")
    assert_equal [["a", "b", "c"], ["e", "f"]], s

    s = %w[a b c d e f].split("a")
    assert_equal [[], %w[b c d e f]], s

    s = %w[a b c d e f].split("f")
    assert_equal [%w[a b c d e]], s

    s = ["a"].split("a")
    assert_equal [[]], s
  end

  def test_split_2
    s = %w[a b c d e f].split("d", :capture => true)
    assert_equal [["a", "b", "c"], "d", ["e", "f"]], s

    s = %w[a b c d e f].split("a", :capture => true)
    assert_equal [[], "a", %w[b c d e f]], s

    s = %w[a b c d e f].split("f", :capture => true)
    assert_equal [%w[a b c d e], "f"], s

    s = ["a"].split("a", :capture => true)
    assert_equal [[], "a"], s
  end

  def test_split_3
    s = %w[a b c d e f].split { |t| t == "d" }
    assert_equal [["a", "b", "c"], ["e", "f"]], s

    s = %w[a b c d e f].split { |t| t == "a" }
    assert_equal [[], %w[b c d e f]], s

    s = %w[a b c d e f].split { |t| t == "f" }
    assert_equal [%w[a b c d e]], s

    s = ["a"].split { |t| t == "a" }
    assert_equal [[]], s

    s = [].split { flunk }
    assert_equal [[]], s
  end

  def test_split_4
    s = %w[a b c d e f].split(:capture => true) { |t| t == "d" }
    assert_equal [["a", "b", "c"], "d", ["e", "f"]], s

    s = %w[a b c d e f].split(:capture => true) { |t| t == "a" }
    assert_equal [[], "a", %w[b c d e f]], s

    s = %w[a b c d e f].split(:capture => true) { |t| t == "f" }
    assert_equal [%w[a b c d e], "f"], s

    s = ["a"].split(:capture => true) { |t| t == "a" }
    assert_equal [[], "a"], s

    s = [].split(:capture => true) { flunk }
    assert_equal [[]], s
  end
  
  def test_split_5
    assert_equal ["", "a", "", "a"], "aa".split(%r!(a)!)
    assert_equal [[], "a", [], "a"], %w[a a].split("a", :capture => true)

    assert_equal ["", "a", "", "a", "b"],
                 "aab".split(%r!(a)!)
    assert_equal [[], "a", [], "a", ["b"]],
                 %w[a a b].split("a", :capture => true)

    assert_equal [[], [1, 2], [4, 5]], (0..5).to_a.split { |t| t % 3 == 0 }
  end

  def test_split_6
    assert_raises(ArgumentError) {
      [].split
    }
    assert_raises(ArgumentError) {
      [].split(:capture => true)
    }
    assert_nothing_raised {
      [].split("a")
    }
    assert_raises(ArgumentError) {
      [].split("a") { }
    }
    assert_raises(ArgumentError) {
      [].split("a", "b")
    }
    assert_raises(ArgumentError) {
      [].split("a", :capture => true) { }
    }
    assert_raises(ArgumentError) {
      [].split("a", "b", :capture => true)
    }
  end

  def test_nonempty
    assert_equal false, [].nonempty?
    assert_equal true,  [3].nonempty?
    assert_equal true,  [3, 4].nonempty?
  end
end
