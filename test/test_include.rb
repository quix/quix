$LOAD_PATH.unshift File.dirname(__FILE__) + "/../lib"

require 'test/unit'
require 'open3'
require 'quix/ruby'

class TestInclude < Test::Unit::TestCase
  def test_include
    Dir.chdir(File.dirname(__FILE__)) {
      code = %q{
        $LOAD_PATH.unshift "../lib"
        require 'quix/module/include'

        module A
          def f ; end
        end
  
        module B
          def f ; end
        end

        module C
          include A
          include B
        end

        class D
          include B
          include A
        end
      }
      begin
        stdin, stdout, stderr = Open3.popen3("#{Quix::Ruby::EXECUTABLE} -d -")
        stdin.puts(code)
        stdin.close_write
        assert_equal(stderr.readlines,
          ["Note: replacing C#f with B#f\n",
           "Note: replacing D#f with A#f\n"])
      rescue NotImplementedError
        puts "Skipping #{File.basename(__FILE__)}."
      end
    }
  end
end
