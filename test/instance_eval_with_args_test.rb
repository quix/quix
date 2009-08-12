require File.dirname(__FILE__) + '/quix_test_base'

require 'quix/instance_eval_with_args'

class TestInstanceEvalWithArgs < Test::Unit::TestCase
  def test_instance_eval_with_args
    obj = Class.new do
      def f
        33
      end
    end.new

    actual_f, actual_a, actual_b = nil

    Quix::InstanceEvalWithArgs.instance_eval_with_args(obj, 44, 55) { |a, b|
      actual_f = f
      actual_a = a
      actual_b = b
    }

    assert_equal 33, actual_f
    assert_equal 44, actual_a
    assert_equal 55, actual_b
  end
end
