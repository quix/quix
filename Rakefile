$LOAD_PATH.unshift "./lib"

task :default => :test

task :test do
  require 'test/all.rb'
  Dir["test/test_*.rb"].each { |file|
    require file
  }
end

task :install do
  require 'quix/simple_installer'
  Quix::SimpleInstaller.new.install
end

task :uninstall do
  require 'quix/simple_installer'
  Quix::SimpleInstaller.new.uninstall
end
