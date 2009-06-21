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

  def test_split_options
    obj = Class.new {
      def f(*args)
        args, opts = split_options(args)
      end
    }.new

    args, opts = obj.f
    assert_equal [], args
    assert_equal Hash.new, opts

    args, opts = obj.f(:a)
    assert_equal [:a], args
    assert_equal Hash.new, opts

    args, opts = obj.f(:a, :b)
    assert_equal [:a, :b], args
    assert_equal Hash.new, opts

    args, opts = obj.f(:a => 33)
    assert_equal [], args
    assert_equal({:a => 33}, opts)

    args, opts = obj.f(:a => 33, :b => 44)
    assert_equal [], args
    assert_equal({:a => 33, :b => 44}, opts)

    args, opts = obj.f(:x, :a => 33)
    assert_equal [:x], args
    assert_equal({:a => 33}, opts)

    args, opts = obj.f(:x, :y, :a => 33)
    assert_equal [:x, :y], args
    assert_equal({:a => 33}, opts)

    args, opts = obj.f(:x, :y, :a => 33, :b => 44)
    assert_equal [:x, :y], args
    assert_equal({:a => 33, :b => 44}, opts)
  end
end
