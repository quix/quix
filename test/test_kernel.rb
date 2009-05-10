require File.dirname(__FILE__) + "/common"

require "quix/ext/kernel"

class TestKernel < Test::Unit::TestCase
  include TestDataDir
  def test_sys
    capture_io {
      assert_raises(RuntimeError) {
        sys("zzzzz")
      }
      assert_nothing_raised {
        sys("echo > #{DATA_DIR}/out")
      }
    }
  end
end
