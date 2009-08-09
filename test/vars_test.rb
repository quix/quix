require File.dirname(__FILE__) + "/common"

require 'quix/vars'
require 'quix/ruby'

stray_toplevel_local = 33

class TestVars < Test::Unit::TestCase
  include Quix::Vars

  def test_locals_to_hash
    a = 33
    b = Object.new
    c = lambda { a + 11 }

    hash = locals_to_hash {%{a b c}}

    assert_equal(a.object_id, hash[:a].object_id)
    assert_equal(b.object_id, hash[:b].object_id)
    assert_equal(c.object_id, hash[:c].object_id)

    assert_equal(hash[:c].call, 44)
  end

  def test_hash_to_locals
    a = nil
    b = nil
    c = nil
    
    hash = {
      :a => 33,
      :b => Object.new,
      :c => lambda { hash[:a] + 11 },
    }

    hash_to_locals { hash }

    assert_equal(a.object_id, hash[:a].object_id)
    assert_equal(b.object_id, hash[:b].object_id)
    assert_equal(c.object_id, hash[:c].object_id)

    assert_equal(hash[:c].call, 44)
    assert_nothing_raised { hash_to_locals { nil } }
  end

  def test_locals_to_ivs
    a = 33
    b = Object.new
    c = lambda { a + 11 }

    assert(!defined?(@a))
    assert(!defined?(@b))
    assert(!defined?(@c))
    
    locals_to_ivs {%{a b c}}

    assert_equal(a.object_id, @a.object_id)
    assert_equal(b.object_id, @b.object_id)
    assert_equal(c.object_id, @c.object_id)

    assert_equal(@c.call, 44)
  end

  def test_hash_to_ivs
    hash = {
      :d => 33,
      :e => Object.new,
      :f => lambda { hash[:d] + 11 },
    }

    assert(!defined?(@d))
    assert(!defined?(@e))
    assert(!defined?(@f))
    assert(!defined?(@g))
    
    hash_to_ivs(hash, :d, :e, :f, :g)

    assert_equal(hash[:d].object_id, @d.object_id)
    assert_equal(hash[:e].object_id, @e.object_id)
    assert_equal(hash[:f].object_id, @f.object_id)
    assert_equal(hash[:g].object_id, @g.object_id)

    assert_equal(nil, hash[:g])
    assert_equal(nil.object_id, @g.object_id)

    assert_equal(44, hash[:f].call)
    assert_equal(44, @f.call)
  end

  def test_hash_to_readers
    hash = {
      :d => 33,
      :e => Object.new,
      :f => lambda { hash[:d] + 11 },
    }

    klass = Class.new {
      include Quix::Vars
      def initialize(hash)
        hash_to_readers(hash, :d, :e, :f, :g)
      end
    }

    obj = klass.new(hash)

    assert_equal(hash[:d].object_id, obj.d.object_id)
    assert_equal(hash[:e].object_id, obj.e.object_id)
    assert_equal(hash[:f].object_id, obj.f.object_id)

    assert_equal(nil, hash[:g])
    assert_equal(nil.object_id, obj.g.object_id)

    assert_equal(44, hash[:f].call)
    assert_equal(44, obj.f.call)
  end

  class A
    def initialize
      @x = 22
      @y = 33
    end
  end

  def test_config_to_hash
    config = %q{
      a = 33
      b = a + 11
      c = 5*(a - 22)
      d = (1..3).map { |n| n*n }
      e = "moo"
      f = lambda { a + 66 }

      a_object_id = a.object_id
      b_object_id = b.object_id
      c_object_id = c.object_id
      d_object_id = d.object_id
      e_object_id = e.object_id
      f_object_id = f.object_id
    }

    hash = config_to_hash(config)

    assert_equal(hash[:a], 33)
    assert_equal(hash[:b], 44)
    assert_equal(hash[:c], 55)
    assert_equal(hash[:d], [1, 4, 9])
    assert_equal(hash[:e], "moo")
    assert_equal(hash[:f].call, 99)

    assert_equal(hash[:a].object_id, hash[:a_object_id])
    assert_equal(hash[:b].object_id, hash[:b_object_id])
    assert_equal(hash[:c].object_id, hash[:c_object_id])
    assert_equal(hash[:d].object_id, hash[:d_object_id])
    assert_equal(hash[:e].object_id, hash[:e_object_id])
    assert_equal(hash[:f].object_id, hash[:f_object_id])

    assert(!hash.has_key?(:stray_toplevel_local))
  end
end
