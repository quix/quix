$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

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
