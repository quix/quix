require File.dirname(__FILE__) + "/common"

require 'rbconfig'

if Config::CONFIG["host"] =~ %r!darwin!
  require "quix/symbol_generator"

  #
  # Try to demonstrate symbol recycling by calling GC.start on each pass
  # through a symbol-generating loop.
  #
  # I have not yet seen jruby call the finalizers required for symbol
  # recycling.
  #
  class TestSymbolGenerator < Test::Unit::TestCase
    class Stuff
      def initialize(track, a, b)
        @a = a
        @b = b
        if track
          Quix::SymbolGenerator.track(self, @a, @b)
        end
      end
    end

    def test_symbol_generator_1
      histogram = Hash.new { |hash, key| hash[key] = 0 }

      [false, true].each { |track|
        300.times { |n|
          a, b = (0..1).map { Quix::SymbolGenerator.gensym }
          obj = Stuff.new(track, a, b)
          histogram[a] += 1
          histogram[b] += 1
          GC.start
        }
        assert_equal(track, histogram.values.any? { |t| t > 1 })
      }
    end
  end
end
