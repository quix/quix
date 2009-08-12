require File.dirname(__FILE__) + '/quix_test_base'

require "quix/ext/object"

class TestObject < Test::Unit::TestCase
  def test_singleton_class
    a = "a"
    assert_equal((class << a ; self ; end), a.singleton_class)
  end

  def test_tap
    value = Object.new
    result = value.tap { |t|
      assert_equal value.object_id, t.object_id
      nil
    }
    assert_equal value.object_id, result.object_id
  end

  def test_let
    value = Object.new
    result = value.let { |t|
      assert_equal value.object_id, t.object_id
      "z"
    }
    assert_equal "z", result
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
