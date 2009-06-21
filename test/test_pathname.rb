require File.dirname(__FILE__) + "/common"

require "quix/ext/pathname"

class TestPathname < Test::Unit::TestCase
  include TestDataDir

  def test_ext
    assert_equal("a/b/c.o", Pathname.new("a/b/c.rb").ext("o").to_s)
    assert_equal("c.o", Pathname.new("c.f").ext("o").to_s)
  end

  def test_stem
    assert_equal("a/b/c", Pathname.new("a/b/c.rb").stem.to_s)
    assert_equal("a.b", Pathname.new("a.b.c").stem.to_s)
  end

  def test_explode
    path = Pathname.new "a/b/c/d.h"
    assert_equal(%w(a b c d.h).map { |t| Pathname.new t }, path.explode)
  end

  def test_restring
    path = Pathname.new "a/b"
    path_xy = path.restring { |t| t.tr("ab", "xy") }
    assert_equal(Pathname.new("x/y"), path_xy)
    assert_equal("x/y", path_xy.to_s)
  end

  if File::ALT_SEPARATOR == "\\"
    def test_to_dos
      assert_equal "a\\b", Pathname.new("a/b").to_dos
    end
  end

  def test_match
    assert_block {
      Pathname.new("a/b") =~ %r!\Aa/b\Z!
    }
  end

  def test_empty_directory
    assert Pathname(DATA_DIR).empty_directory?
  end

  def test_join
    path = Pathname.new "a/b/c/d.h"
    assert_equal(
      Pathname.new("b/c/d.h"),
      Pathname.join(*path.explode[1..-1])
    )
  end

  def test_slice
    assert_equal Pathname("a/b/c").slice(0..-1), Pathname("a/b/c")
    assert_equal Pathname("a/b/c").slice(1..-1), Pathname("b/c")
    assert_equal Pathname("a/b/c").slice(1..2), Pathname("b/c")
    assert_equal Pathname("a/b/c").slice(0..1), Pathname("a/b")
    assert_equal Pathname("a/b/c").slice(0..0), Pathname("a")
    assert_equal Pathname("a/b/c").slice(0...0), Pathname("")
  end
end
