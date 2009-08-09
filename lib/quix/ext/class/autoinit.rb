
require 'quix/temp_method'

class Class

  #
  # autoinit is found in Gavin Sinclair's extensions package.  The
  # following is my own implementation which does not use eval().
  #
  # autoinit_options and other methods are contrariwise unique to this
  # package.
  #
  def autoinit(*names, &block)
    # TODO: jettison 1.8.6; use |&block|

    if block and not [-1, 0].include?(block.arity)
      raise ArgumentError, "autoinit block must have no arguments"
    end

    define_method :initialize do |*values|
      unless values.size == names.size
        raise ArgumentError,
        "wrong number of arguments (#{values.size} for #{names.size})"
      end
      names.zip(values) { |name, value|
        instance_variable_set("@#{name}", value)
      }
      if block
        Quix::TempMethod.call_temp_method(self, :__autoinit, &block)
      end
    end
  end

  def autoinit_options(*keys, &block)
    # TODO: jettison 1.8.6; use |&block|

    define_method :initialize do |*args|
      options = args.last.is_a?(Hash) ? args.pop : Hash.new
      expected_args_size = (
        if block.nil?
          0
        elsif block.arity == -1
          :any
        else
          block.arity
        end
      )
      case expected_args_size
      when :any, args.size
        # ok
      else
        raise ArgumentError,
        "wrong number of arguments (#{args.size} for #{expected_args_size})"
      end
      keys.zip(options.values_at(*keys)) { |key, value|
        instance_variable_set("@#{key}", value)
      }
      if block
        Quix::TempMethod.
        call_temp_method(self, :__autoinit_options, *args, &block)
      end
    end
  end

  #
  # TODO: jettison 1.8.6; use |&block|
  #
  #["", "_options"].each { |infix|
  #  %w[reader writer accessor].each { |suffix|
  #    base = "autoinit#{infix}"
  #    define_method "#{base}_#{suffix}" do |*args, &block|
  #      send("attr_#{suffix}", *args)
  #      send(base, *args, &block)
  #    end
  #  }
  #}
  #

  def autoinit_reader(*names, &block)
    attr_reader(*names)
    autoinit(*names, &block)
  end

  def autoinit_options_reader(*keys, &block)
    attr_reader(*keys)
    autoinit_options(*keys, &block)
  end

  def autoinit_writer(*names, &block)
    attr_writer(*names)
    autoinit(*names, &block)
  end

  def autoinit_options_writer(*keys, &block)
    attr_writer(*keys)
    autoinit_options(*keys, &block)
  end

  def autoinit_accessor(*names, &block)
    attr_accessor(*names)
    autoinit(*names, &block)
  end

  def autoinit_options_accessor(*keys, &block)
    attr_accessor(*keys)
    autoinit_options(*keys, &block)
  end
end
