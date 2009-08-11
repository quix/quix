require File.dirname(__FILE__) + "/common"

require "stringio"
require "quix/diagnostic"

class TestDiagnostic < Test::Unit::TestCase
  include Quix::Diagnostic

  def test_diagnostic_1
    out = StringIO.new
    desc = "zzz"
    a = 33
    previous = $VERBOSE
    $VERBOSE = false
    begin
      show(desc, out) {%{a}}
    ensure
      $VERBOSE = previous
    end
    lines = out.string.split("\n").map { |t| t.chomp }
    assert_equal desc, lines[0]
    assert_match %r!\A\s*a\s+=>\s*#{a}\s*\Z!, lines[1]
  end

  def test_diagnostic_2
    out = StringIO.new
    a = 33
    show(nil, out) {%{a}}
    assert_match %r!\A\s*a\s+=>\s*#{a}\s*\Z!, out.string
  end

  def test_diagnostic_3
    prev_debug = $DEBUG
    prev_stderr = $stderr
    begin
      $stderr = StringIO.new
      a = 33

      $DEBUG = false
      memo = Array.new
      debug { memo.push :data }
      assert_equal 0, memo.size
      assert_equal false, debugging?
      trace {%{a}}
      assert_equal "", $stderr.string
      trace(nil) {%{a}}
      assert_equal "", $stderr.string

      $DEBUG = true
      memo = Array.new
      debug { memo.push :data }
      assert_equal 1, memo.size
      assert_equal :data, memo.first
      assert_equal true, debugging?
      previous = $VERBOSE
      $VERBOSE = false
      begin
        trace {%{a}}
      ensure
        $VERBOSE = previous
      end
      assert_match %r!\A\s*a\s+=>\s*#{a}\s*\Z!, $stderr.string
    ensure
      $DEBUG = prev_debug
      $stderr = prev_stderr
    end
  end
end
