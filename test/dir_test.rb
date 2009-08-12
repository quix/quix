require File.dirname(__FILE__) + '/quix_test_base'

require 'quix/ext/dir'
require 'quix/ext/pathname'

class TestDir < Test::Unit::TestCase
  include FileUtils
  include TestDataDir

  def test_dir
    assert_equal(true, Dir.empty?(DATA_DIR))
    touch "#{DATA_DIR}/t"
    assert_equal(false, Dir.empty?(DATA_DIR))
  end

  def test_glob
    file = "#{DATA_DIR}/a"
    touch file

    files = Dir.glob("#{DATA_DIR}/*")
    assert_equal [file], files

    files = Dir.glob(Pathname("#{DATA_DIR}/*"))
    assert_equal [file], files

    files = Dir.glob(["#{DATA_DIR}/*"])
    assert_equal [file], files

    files = Dir.glob([Pathname("#{DATA_DIR}/*")])
    assert_equal [file], files
  end
end
