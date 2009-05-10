require File.dirname(__FILE__) + "/common"

require "quix/ext/string"

class TestString < Test::Unit::TestCase
  def test_captures
    "  xx  yy ".captures(%r!\A\s*(\w+)\s+(\w+)\s*\Z!) { |a, b|
      assert_equal "xx", a
      assert_equal "yy", b
    }
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
end
