require File.dirname(__FILE__) + "/common"

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
          Ruby.module_eval {
            remove_const :EXECUTABLE
          }
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
end
