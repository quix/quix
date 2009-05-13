require File.dirname(__FILE__) + "/common"

require 'quix/assert'

class TestAssert < Test::Unit::TestCase
  Assert = Quix::Assert

  def test_1
    previous = $DEBUG
    begin
      $DEBUG = true
      error = assert_raises(Quix::Assert::AssertionFailed) {
        capture_io {
          Assert.assert {%{ 1 == 2 }}
        }
      }
      assert_equal "assertion failed: `1 == 2'", error.message
      
      assert_nothing_raised {
        Assert.assert {%{ 1 == 1 }}
      }
      assert_nothing_raised {
        Assert.assert {%{ 1 == 2 - 1 }}
      }
    ensure
      $DEBUG = previous
    end
  end
end

