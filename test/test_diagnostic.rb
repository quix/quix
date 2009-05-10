require File.dirname(__FILE__) + "/common"

require "stringio"
require "quix/diagnostic"

class TestDiagnostic < Test::Unit::TestCase
  include Quix::Diagnostic

  def test_1
    out = StringIO.new
    desc = "zzz"
    a = 33
    show(desc, out) {%{a}}
    lines = out.string.lines.map { |t| t.chomp }
    assert_equal desc, lines[0]
    assert_match %r!\A\s*a\s+=>\s*#{a}\s*\Z!, lines[1]
  end

  def test_2
    out = StringIO.new
    a = 33
    show(nil, out) {%{a}}
    assert_match %r!\A\s*a\s+=>\s*#{a}\s*\Z!, out.string
  end

  def test_3
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
      trace {%{a}}
      assert_match %r!\A\s*a\s+=>\s*#{a}\s*\Z!, $stderr.string
    ensure
      $DEBUG = prev_debug
      $stderr = prev_stderr
    end
  end
end
