require File.dirname(__FILE__) + "/common"

require "quix/ext/module"

class TestModule < Test::Unit::TestCase
  def test_module
    mod = Module.new {
      define_module_function :f do
        "f"
      end
      define_public_method :g do
        "g"
      end
      define_protected_method :h do
        "h"
      end
      define_private_method :i do
        "i"
      end
    }

    assert_equal "f", mod.f

    klass = Class.new {
      include mod
    }

    assert klass.instance_methods.include?("g")
    assert klass.instance_methods.include?("h")
    assert_equal false, klass.instance_methods.include?("f")
    assert_equal false, klass.instance_methods.include?("i")

    test = self

    klass.class_eval {
      define_method :check do
        test.assert_equal "f", f
        test.assert_equal "g", g
        test.assert_equal "h", h
        test.assert_equal "i", i
      end
    }

    klass.new.check
    assert_equal "g", klass.new.g
  end
end
