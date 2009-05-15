require File.dirname(__FILE__) + "/common"

require 'rbconfig'

if Config::CONFIG["host"] =~ %r!darwin!
  require "quix/ext/fileutils"

  class TestFileUtils < Test::Unit::TestCase
    include FileUtils
    include TestDataDir

    def test_rename_file
      Dir.chdir(DATA_DIR) {
        touch "x"
        rename_file "x", "X"
        assert_equal ["X"], Dir["*"] 
      }
    end

    def test_replace_file
      Dir.chdir(DATA_DIR) {
        file = "f"
        File.open(file, "w") { |out|
          out.print("a")
        }
        assert_equal "a", File.read(file)
        
        replace_file(file) { |contents|
          contents.gsub "a", "b"
        }
        assert_equal "b", File.read(file)
      }
    end

    def test_write_file
      Dir.chdir(DATA_DIR) {
        write_file("g") {
          "c"
        }
        assert_equal "c", File.read("g")
      }
    end

    def test_rename_file_error
      source = "x"
      begin
        dest = "#{DATA_DIR}/y"
        temp = File.join(Dir.tmpdir, File.basename(source))
        thread = Thread.new {
          loop {
            rm_f temp
          }
        }
        assert_raises(Errno::ENOENT) {
          loop {
            touch source
            rename_file source, dest
          }
        }
        thread.kill
        
        rm_rf DATA_DIR
        touch source
        assert_raises(Errno::ENOENT) {
          rename_file source, dest
        }
        
        # for teardown
        mkdir DATA_DIR
      ensure
        rm_f source
      end
    end
  end
end
