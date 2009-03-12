$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

require 'test/unit'
require 'quix/module'

class TestPolite < Test::Unit::TestCase
  class A
    def f
      33
    end

    polite {
      def f
        44
      end
    }
  end

  def test_a
    assert_equal(33, A.new.f)
  end

  class ::String
    polite {
      def size
        55
      end

      def size_duh
        66
      end
    }
  end

  def test_string
    assert_equal(0, "".size)
    assert_equal(66, "".size_duh)
  end
  
  module B
    polite {
      def f
      end

      private

      def g
      end

      module_function

      def h
        77
      end
    }
  end

  def test_b
    assert(B.instance_methods.map { |t| t.to_sym }.include? :f)
    assert_block {
      B.private_instance_methods.map { |t| t.to_sym }.include?(:g)
    }
    assert_block {
      not B.instance_methods.map { |t| t.to_sym }.include?(:g)
    }
    assert_block {
      B.methods.map { |t| t.to_sym }.include?(:h)
    }
    assert_block {
      B.private_instance_methods.map { |t| t.to_sym }.include?(:h)
    }
    assert_equal(77, B.h)
  end

  module C
    polite do
      protected

      def f
      end
      module_function :f

      def g
      end
      private :g
    end
  end

  def test_c
    assert_block {
      C.methods.map { |t| t.to_sym }.include?(:f)
    }
    assert_block {
      C.private_instance_methods.map { |t| t.to_sym }.include?(:f)
    }
    assert_block {
      not C.methods.map { |t| t.to_sym }.include?(:g)
    }
    assert_block {
      C.private_instance_methods.map { |t| t.to_sym }.include?(:g)
    }
  end
end
