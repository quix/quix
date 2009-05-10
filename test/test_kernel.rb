require File.dirname(__FILE__) + "/common"

require "quix/ext/kernel"

class TestKernel < Test::Unit::TestCase
  def test_sys
    assert_raises(RuntimeError) {
      sys("zzzzzzzzzzzzzzzzzzzzz")
    }
    assert_nothing_raised {
      sys("echo")
    }
  end
end
