require 'fileutils'
require 'ls_pair/exception'

module LsPair
  class Filesystem
    include FileUtils
    class FileNotFound < LsPair::Exception
    end

    public :chmod, :chown_R

    def read_file(path)
      File.read(path)
    rescue Errno::ENOENT
      raise FileNotFound, '%s not found!' % path
    end

    def create_file(path, content)
      mkdir_p File.dirname(path)
      File.open(path, 'w') do |f|
        f.write content
      end
    end

    def entries(path)
      Dir.entries(path)
    end
  end
end
