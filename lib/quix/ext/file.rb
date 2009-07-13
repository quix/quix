
require 'rbconfig'
cygwin = Config::CONFIG["host"] =~ %r!cygwin!
dosish = File::ALT_SEPARATOR == "\\"
require 'quix/ext/windows/file' if cygwin or dosish
