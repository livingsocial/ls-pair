require 'ls_pair/directory_service'
require 'ls_pair/filesystem'
require 'ls_pair/ssh_keys'
require 'ls_pair/wemux_command'

module LsPair
  class LocalUser
    def initialize(username, options = {})
      @options = options
      @username = username
    end

    def provision(auto_wemux_mode = "pair")
      ensure_ssh_key_exists
      ensure_user_exists
      set_up_ssh_dir
      set_home_dir_permissions
      set_auto_wemux_command auto_wemux_mode
    rescue LsPair::SshKeys::NoPublicKeyForUser => e
      puts e.message
    end

    private

    def filesystem
      @options[:filesystem] || Filesystem.new
    end

    def directory_service
      @options[:directory_service] || DirectoryService.new
    end

    def ssh_keys
      @options[:ssh_keys] || SshKeys.new
    end

    def wemux_command
      @options[:wemux_command] || WemuxCommand.new
    end

    def home_dir
      "/Users/#{@username}"
    end

    def public_ssh_key
      ssh_keys.read(@username)
    end
    alias :ensure_ssh_key_exists :public_ssh_key  # raises if file isn't there

    def ensure_user_exists
      return if directory_service.user_exists?(@username)
      directory_service.create_user(@username)
    end

    def authorized_keys_path
      "#{ssh_path}/authorized_keys"
    end

    def ssh_path
      "#{home_dir}/.ssh"
    end

    def set_up_ssh_dir
      filesystem.create_file(authorized_keys_path, public_ssh_key)
      filesystem.chmod(0600, authorized_keys_path)
      filesystem.chmod(0700, ssh_path)
    end

    def set_home_dir_permissions
      filesystem.chmod(0755, home_dir)
      filesystem.chown_R(@username, 'staff', home_dir)
    end

    def set_auto_wemux_command(mode)
      wemux_command.set_auto_wemux_command(
        mode,
        filesystem: filesystem,
        home_dir:   home_dir
      )
    end
  end
end
