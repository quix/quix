require File.dirname(__FILE__) + "/common"

require 'quix/ext/class'

class TestClass < Test::Unit::TestCase
  def test_autoinit_no_block
    cls = Class.new do
      autoinit :r, :s
      def data
        [@r, @s]
      end
    end
    assert_equal [33, 44], cls.new(33, 44).data
    assert_raises(ArgumentError) { cls.new(33) }
    assert_raises(ArgumentError) { cls.new(33, 44, 55) }
  end

  def test_autoinit_with_block
    cls = Class.new do
      autoinit :r, :s do
        @t = 55
        f
      end
      
      def f
        @u = 66
      end
      
      def data
        [@r, @s, @t, @u]
      end
    end
    assert_equal [33, 44, 55, 66], cls.new(33, 44).data
    assert_raises(ArgumentError) { cls.new(77) }
    assert_raises(ArgumentError) { cls.new(77, 88, 99) }
  end

  def test_autoinit_with_block_splat
    block_args = nil
    cls = Class.new do
      autoinit :r, :s do |*args|
        block_args = args
        @t = 55
        f
      end
      
      def f
        @u = 66
      end
      
      def data
        [@r, @s, @t, @u]
      end
    end
    assert_equal [33, 44, 55, 66], cls.new(33, 44).data
    assert_equal [], block_args
    assert_raises(ArgumentError) { cls.new(77) }
    assert_raises(ArgumentError) { cls.new(77, 88, 99) }

    cls = Class.new do
      autoinit do |*args|
      end
    end
    assert_nothing_raised { cls.new }
    assert_raises(ArgumentError) { cls.new(77) }
    assert_raises(ArgumentError) { cls.new(77, 88) }
  end

  def test_autoinit_options_no_block
    cls = Class.new do
      autoinit_options :r, :s
      def data
        [@r, @s]
      end
    end
    assert_equal [33, 44], cls.new(:r => 33, :s => 44).data
    assert_equal [33, nil], cls.new(:r => 33).data
    assert_equal [nil, 44], cls.new(:s => 44).data
    assert_equal [nil, nil], cls.new.data
    assert_raises(ArgumentError) { cls.new(33) }
    assert_raises(ArgumentError) { cls.new(33, 44, 55) }
  end

  def test_autoinit_options_with_block
    cls = Class.new do
      autoinit_options :t, :u do |r, s|
        @r = r
        @s = s
        f
      end
      
      def f
        @v = 77
      end
      
      def data
        [@r, @s, @t, @u, @v]
      end
    end
    assert_equal [33, 44, 55, 66, 77], cls.new(33, 44, :t => 55, :u => 66).data
    assert_equal [33, 44, nil, nil, 77], cls.new(33, 44).data
    assert_raises(ArgumentError) { cls.new(33) }
    assert_raises(ArgumentError) { cls.new(33, 44, 55) }
  end

  def test_autoinit_options_with_block_splat
    cls = Class.new do
      autoinit_options :t, :u do |*args|
        @r = args[0]
        @s = args[1]
        f
      end
      
      def f
        @v = 77
      end
      
      def data
        [@r, @s, @t, @u, @v]
      end
    end
    assert_equal [33, 44, 55, 66, 77], cls.new(33, 44, :t => 55, :u => 66).data
    assert_equal [33, 44, nil, nil, 77], cls.new(33, 44).data
    assert_nothing_raised { cls.new }
    assert_nothing_raised { cls.new(33) }
    assert_nothing_raised { cls.new(33, 44, 55) }

    block_args = nil
    cls = Class.new do
      autoinit_options do |*args|
        block_args = args
      end
    end
    assert_nothing_raised { cls.new }
    assert_equal [], block_args
    assert_nothing_raised { cls.new(33) }
    assert_equal [33], block_args
    assert_nothing_raised { cls.new(33, 44) }
    assert_equal [33, 44], block_args
  end

  def test_autoinit_border
    cls = Class.new do
      autoinit
    end
    assert_nothing_raised { cls.new }
    assert_raises(ArgumentError) { cls.new(33) }

    cls = Class.new do
      autoinit do
      end
    end
    assert_nothing_raised { cls.new }
    assert_raises(ArgumentError) { cls.new(33) }

    cls = Class.new do
      autoinit do ||
      end
    end
    assert_nothing_raised { cls.new }
    assert_raises(ArgumentError) { cls.new(33) }

    cls = Class.new do
      autoinit :x do ||
      end
    end
    assert_nothing_raised { cls.new(33) }
    assert_raises(ArgumentError) { cls.new }

    error = assert_raises(ArgumentError) {
      Class.new do
        autoinit do |x|
        end
      end
    }
    assert_equal "autoinit block must have no arguments", error.message
  end

  def test_autoinit_options_border
    # ruby implementation sanity check
    assert_equal(-1, lambda { |*args| }.arity)
    assert_equal(0, lambda { || }.arity)

    cls = Class.new do
      autoinit_options 
    end
    assert_nothing_raised { cls.new }
    assert_raises(ArgumentError) { cls.new(33) }

    cls = Class.new do
      autoinit_options do
      end
    end
    assert_nothing_raised { cls.new }
    if lambda { }.arity == -1
      # blah; 1.8 cannot distinguish between no-argument and splat
      assert_nothing_raised { cls.new(33) }
    elsif lambda { }.arity == 0
      assert_raises(ArgumentError) { cls.new(33) }
    else
      raise "strange ruby implementation"
    end

    cls = Class.new do
      autoinit_options do ||
      end
    end
    assert_nothing_raised { cls.new }
    assert_raises(ArgumentError) { cls.new(33) }

    cls = Class.new do
      autoinit_options do |x|
      end
    end
    assert_nothing_raised { cls.new(33) }
    assert_raises(ArgumentError) { cls.new }
  end

  def test_raises
    flag = "---flag"
    cls = Class.new do
      autoinit do
        raise flag
      end
    end
    error = assert_raises(RuntimeError) { cls.new }
    assert_equal flag, error.message

    cls = Class.new do
      autoinit_options do
        raise flag
      end
    end
    error = assert_raises(RuntimeError) { cls.new }
    assert_equal flag, error.message
  end

  def test_autoinit_reader
    cls = Class.new do
      autoinit_reader :r, :s
    end
    a = cls.new(33, 44)
    assert_equal 33, a.r
    assert_equal 44, a.s

    assert_raises(NoMethodError) { a.r = 55 }
  end

  def test_autoinit_options_reader
    cls = Class.new do
      autoinit_options_reader :r, :s
    end

    a = cls.new(:r => 33, :s => 44)
    assert_equal 33, a.r
    assert_equal 44, a.s

    assert_raises(NoMethodError) { a.r = 55 }
  end

  def test_autoinit_writer
    cls = Class.new do
      autoinit_writer :r, :s
    end
    a = cls.new(33, 44)
    assert_equal 33, a.instance_eval { @r }
    assert_equal 44, a.instance_eval { @s }

    a.r, a.s = 55, 66
    assert_equal 55, a.instance_eval { @r }
    assert_equal 66, a.instance_eval { @s }

    assert_raises(NoMethodError) { a.r }
  end

  def test_autoinit_options_writer
    cls = Class.new do
      autoinit_options_writer :r, :s
    end

    a = cls.new(:r => 33, :s => 44)
    assert_equal 33, a.instance_eval { @r }
    assert_equal 44, a.instance_eval { @s }
    
    a.r, a.s = 55, 66
    assert_equal 55, a.instance_eval { @r }
    assert_equal 66, a.instance_eval { @s }

    assert_raises(NoMethodError) { a.r }
  end

  def test_autoinit_accessor
    cls = Class.new do
      autoinit_accessor :r, :s
    end
    a = cls.new(33, 44)
    assert_equal 33, a.r
    assert_equal 44, a.s

    a.r, a.s = 55, 66
    assert_equal 55, a.r
    assert_equal 66, a.s
  end

  def test_autoinit_options_accessor
    cls = Class.new do
      autoinit_options_accessor :r, :s
    end

    a = cls.new(:r => 33, :s => 44)
    assert_equal 33, a.r
    assert_equal 44, a.s
    
    a.r, a.s = 55, 66
    assert_equal 55, a.r
    assert_equal 66, a.s
  end
end
