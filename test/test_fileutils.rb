require File.dirname(__FILE__) + "/common"

require "quix/ext/fileutils"

class TestFileUtils < Test::Unit::TestCase
  include FileUtils
  include TestDataDir

  def test_mv
    Dir.chdir(DATA_DIR) {
      touch "x"
      mv "x", "X"
      assert_equal ["X"], Dir["*"] 
    }
  end

  def test_replace_file
    Dir.chdir(DATA_DIR) {
      file = "f"
      File.open(file, "w") { |out|
        out.print("a")
      }
      assert_equal "a", File.read(file)
      
      replace_file(file) { |contents|
        contents.gsub "a", "b"
      }
      assert_equal "b", File.read(file)
    }
  end

  def test_write_file
    Dir.chdir(DATA_DIR) {
      write_file("g") {
        "c"
      }
      assert_equal "c", File.read("g")
    }
  end
end
