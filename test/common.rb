$LOAD_PATH.unshift File.dirname(__FILE__) + "/../lib"

require "fileutils"
require "test/unit"
require "rubygems"
require "rake"

RakeFileUtils.verbose_flag = false

module TestDataDir
  DATA_DIR = "testdata"

  def setup
    FileUtils.mkdir DATA_DIR
  end

  def teardown
    FileUtils.rm_r DATA_DIR
  end
end

# from minitest, copyright (c) Ryan Davis
def capture_io
  require 'stringio'

  orig_stdout, orig_stderr         = $stdout, $stderr
  captured_stdout, captured_stderr = StringIO.new, StringIO.new
  $stdout, $stderr                 = captured_stdout, captured_stderr

  yield

  return captured_stdout.string, captured_stderr.string
ensure
  $stdout = orig_stdout
  $stderr = orig_stderr
end
