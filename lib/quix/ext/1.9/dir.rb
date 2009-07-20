
class Dir
  class << self
    alias_method :quix_original_glob, :glob
    def glob(pattern, *args, &block)
      result = (
        case pattern
        when Enumerable
          begin
            pattern.map { |t| t.to_path }
          rescue
            pattern.map { |t| t.to_s }
          end
        else
          begin
            pattern.to_path
          rescue
            pattern.to_s
          end
        end
      )
      quix_original_glob(result, *args, &block)
    end
  end
end
