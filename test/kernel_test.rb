require File.dirname(__FILE__) + '/quix_test_base'

require "quix/ext/kernel"
require 'jumpstart'

class TestKernel < Test::Unit::TestCase
  include TestDataDir
  def test_sys
    Jumpstart.capture_io {
      assert_raises(RuntimeError) {
        sys("zzzzz")
      }
      assert_nothing_raised {
        sys("echo > #{DATA_DIR}/out")
      }
    }
  end
end
