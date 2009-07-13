
class String
  def captures(re)
    result = match(re)
    if result and not result.captures.empty?
      yield(*result.captures)
    end
  end

  {
    :gsub => :gsubx,
    :gsub! => :gsubx!,
    :sub => :subx,
    :sub! => :subx!,
  }.each_pair { |source, dest|
    # use eval for < 1.8.7 compatibility
    eval <<-end_eval
      def #{dest}(*args)
        if block_given?
          #{source}(*args) {
            yield Regexp.last_match
          }
        else
          #{source}(*args)
        end
      end
    end_eval
  }

  def nonempty?
    not empty?
  end
end

