require File.dirname(__FILE__) + "/common"

require "quix/ext/object"

class TestObject < Test::Unit::TestCase
  def test_singleton_class
    a = "a"
    assert_equal((class << a ; self ; end), a.singleton_class)
  end

  def test_tap
    ret = "a".tap { |t|
      assert_equal "a", t
      nil
    }
    assert_equal "a", ret
  end

  def test_let
    ret = "a".let { |t|
      assert_equal "a", t
      "b"
    }
    assert_equal "b", ret
  end

  def test_try
    klass = Class.new {
      def f(*args)
        "f - #{args.inspect}"
      end

      def g
        nil
      end
    }
    assert_equal "f - []", klass.new.try(:f)
    assert_equal "f - [1, 2]", klass.new.try(:f, 1, 2)
    assert_equal nil, nil.try(:f)
    assert_equal nil, klass.new.try(:g).try(:z)
  end
end
