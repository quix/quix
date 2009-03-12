
require 'pathname'
require 'quix/module'

class Pathname
  polite do
    def ext(new_ext)
      sub(%r!#{extname}\Z!, ".#{new_ext}")
    end
  
    def stem
      sub(%r!#{extname}\Z!, "")
    end

    def explode
      to_s.split(::Pathname::SEPARATOR_PAT).map { |path|
        Pathname.new path
      }
    end

    def restring
      Pathname.new(yield(to_s))
    end

    def to_dos
      to_s.gsub("/", "\\")
    end
  end

  #
  # special case: ruby-1.9 has undef on Pathname#=~
  # including a module with =~ will NOT make it defined
  #
  unless instance_method_defined? :=~
    def =~(regexp)
      to_s =~ regexp
    end
  end

  class << self
    polite do
      def join(*paths)
        Pathname.new File.join(*paths)
      end
    end
  end
end

