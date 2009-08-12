require File.dirname(__FILE__) + '/quix_test_base'

require "quix/ext/string"

class TestString < Test::Unit::TestCase
  def test_captures
    called = false
    "  xx  yy ".captures(%r!\A\s*(\w+)\s+(\w+)\s*\Z!) { |a, b|
      called = true
      assert_equal "xx", a
      assert_equal "yy", b
    }
    assert called
  end

  def test_match_data
    %w[subx subx! gsubx gsubx!].each { |method|
      res = "abc".send(method, %r!\Aa(.)!) { |md|
        assert_equal ["b"], md.captures
        "ax"
      }
      assert_equal "axc", res
    }
  end

  def test_nonempty
    assert_equal false, "".nonempty?
    assert_equal true,  "3".nonempty?
    assert_equal true,  "34".nonempty?
  end
end
