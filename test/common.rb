$LOAD_PATH.unshift File.dirname(__FILE__) + "/../lib"

require "test/unit"
require "fileutils"

module TestDataDir
  DATA_DIR = "testdata"

  def setup
    FileUtils.mkdir DATA_DIR
  end

  def teardown
    FileUtils.rm_r DATA_DIR
  end
end
