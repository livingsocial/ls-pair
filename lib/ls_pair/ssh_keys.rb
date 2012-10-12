require 'ls_pair/exception'
require 'ls_pair/filesystem'

module LsPair
  class SshKeys
    class NoPublicKeyForUser < LsPair::Exception
    end

    def initialize(options = {})
      @options = options
    end

    def read(username)
      filesystem.read_file(key_path_for(username))
    rescue LsPair::Filesystem::FileNotFound
      raise NoPublicKeyForUser, "No public key for user '#{username}' in #{key_dir}"
    end

    def usernames
      key_files.map { |file_name|
        File.basename(file_name, '.pub')
      }
    end

    private

    def filesystem
      @options[:filesystem] || Filesystem.new
    end

    def key_path_for(username)
      File.join(key_dir, "#{username}.pub")
    end

    def key_dir
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'public_keys'))
    end

    def key_files
      filesystem.entries(key_dir).select { |file_name|
        file_name =~ /\.pub$/
      }
    end
  end
end
