require File.dirname(__FILE__) + "/common"

require 'quix/ext/dir'

class TestDir < Test::Unit::TestCase
  include FileUtils
  include TestDataDir

  def test_dir
    assert_equal(true, Dir.empty?(DATA_DIR))
    touch "#{DATA_DIR}/t"
    assert_equal(false, Dir.empty?(DATA_DIR))
  end
end
