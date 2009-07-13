require File.dirname(__FILE__) + "/common"

require 'quix/ext/file'
require 'fileutils'

class TestFile < Test::Unit::TestCase
  include FileUtils
  include TestDataDir

  def test_rename
    Dir.chdir(DATA_DIR) {
      touch "x"
      File.rename "x", "X"
      assert_equal ["X"], Dir["*"] 
    }
  end
end
