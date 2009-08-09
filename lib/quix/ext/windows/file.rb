
class File
  class << self
    alias_method :quix_original_rename, :rename
    def rename(source, dest)
      if source.to_s.casecmp(dest.to_s) == 0 then
        #
        # For case-insensitive systems, we must move the file elsewhere
        # before changing case.
        #
        temp = "#{dest}.rename.temp"
        quix_original_rename(source, temp)
        begin
          quix_original_rename(temp, dest)
        rescue
          quix_original_rename(temp, source)
          raise
        end
      else
        quix_original_rename(source, dest)
      end
    end
  end
end
