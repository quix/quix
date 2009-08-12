require File.dirname(__FILE__) + '/quix_test_base'

require 'stringio'
require 'quix/ruby'

class TestRuby < Test::Unit::TestCase
  include TestDataDir
  Ruby = Quix::Ruby

  def test_1
    assert File.directory?(DATA_DIR)
    assert_nothing_raised {
      Ruby.run("-rfileutils", "-e", "FileUtils.touch '#{DATA_DIR}/z'")
    }
    assert File.exist?("#{DATA_DIR}/z")
    assert_raises(RuntimeError) {
      Ruby.run("-e", "exit 1")
    }
  end

  def test_2
    unless RUBY_PLATFORM =~ %r!(mswin|cygwin|mingw)!
      previous = Config::CONFIG["host"]
      begin
        Config::CONFIG["host"] = "mingw"
        Ruby.no_warnings {
          load File.dirname(__FILE__) + "/../lib/quix/ruby.rb"
        }
        assert_nothing_raised {
          Ruby.run("-e", "")
        }
      ensure
        Config::CONFIG["host"] = previous
      end
    end
  end

  def test_capture
    assert_equal "77", Quix::Ruby.run_code_and_capture("print(33 + 44)")

    file = "#{DATA_DIR}/abc"
    File.open(file, "w") { |f|
      f.puts("puts(33 + 44)")
      f.puts("puts('abc')")
    }
    assert_equal "77\nabc\n", Quix::Ruby.run_file_and_capture(file)

    assert_raises(RuntimeError) {
      Quix::Ruby.run_file_and_capture("asldfkjdf")
    }
  end
end
