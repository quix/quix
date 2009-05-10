require File.dirname(__FILE__) + "/common"

require "fileutils"
require "quix/casefold_glob"

class TestCasefoldGlob < Test::Unit::TestCase
  include TestDataDir

  FILES = %w[a B c D]

  def setup
    super
    FILES.each { |t| FileUtils.touch "#{DATA_DIR}/#{t}" }
  end

  def test_casefold_glob
    Dir.chdir(DATA_DIR) {
      assert_equal(FILES.sort, Dir["*"].sort)
    }
  end
end
