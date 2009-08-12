require File.dirname(__FILE__) + '/quix_test_base'

require "quix/restricted_value"

class TestRestrictedValue < Test::Unit::TestCase
  def test_restricted_value_1
    assert_kind_of Class, Quix::RestrictedValue.new

    assert_raises(ArgumentError) {
      Quix::RestrictedValue.new(:x).new
    }

    s = Quix::RestrictedValue.new(:x, :y, :z).new(:z)
    assert_equal :z, s.value
    
    s.value = :x
    assert_equal :x, s.value

    s.value = :y
    assert_equal :y, s.value

    error = assert_raises(Quix::RestrictedValue::Error) {
      s.value = :t
    }
    assert_match %r!\`:t\' not in \[:x\, :y\, :z\]!, error.message
  end

  def test_restricted_value_2
    b = Object.new
    s = Quix::RestrictedValue.new("a", b, :c).new("a")
    
    assert_equal "a", s.value

    s.value = b
    assert_equal b, s.value

    s.value = :c
    assert_equal :c, s.value

    assert_raises(Quix::RestrictedValue::Error) {
      s.value = "c"
    }
  end
end
