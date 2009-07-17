require File.dirname(__FILE__) + "/common"

require "quix/ext/pathname"
require "fileutils"

class TestPathname < Test::Unit::TestCase
  include TestDataDir
  include FileUtils

  TEST_FILE = Pathname(DATA_DIR) + "somefile"

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

  def test_draft
    contents = "abcd"
    ret = TEST_FILE.draft { contents }
    assert_equal contents, TEST_FILE.read
    assert_equal contents, ret
  end

  def test_replace
    TEST_FILE.draft { "abcd" }
    ret = TEST_FILE.replace { |contents|
      contents.sub("a", "x").sub("b", "y")
    }
    expected = "xycd"
    assert_equal expected, TEST_FILE.read
    assert_equal expected, ret
  end

  def test_binread
    contents = "ab\r\ncd"
    TEST_FILE.open("wb") { |f| f.print contents}
    assert_equal "b\r\nc", TEST_FILE.binread(4, 1)
  end

  def test_bindraft
    contents = "ab\r\ncd"
    ret = TEST_FILE.bindraft { contents }
    assert_equal contents, TEST_FILE.binread
    assert_equal contents, ret
  end

  def test_binreplace
    TEST_FILE.bindraft { "ab\r\ncd" }
    ret = TEST_FILE.binreplace { |contents|
      contents.sub("a", "x").sub("b", "y")
    }
    expected = "xy\r\ncd"
    assert_equal expected, TEST_FILE.binread
    assert_equal expected, ret
  end

  def test_glob_all
    data_dir = Pathname(DATA_DIR)

    all_files = %w[a .b .c d].map { |t| data_dir + t }
    normal_files = all_files.reject { |t| t.basename.to_s =~ %r!\A\.! }

    touch(all_files)
    
    assert_equal normal_files.sort, Pathname.glob(data_dir + "*").sort
    assert_equal all_files.sort, Pathname.glob_all(data_dir + "*").sort
  end

  if File::ALT_SEPARATOR == "\\"
    def test_initialize
      assert_equal "a/b/c", Pathname("a\\b\\c").to_s
    end
  end
end
