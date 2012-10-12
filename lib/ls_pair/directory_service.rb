require 'ls_pair/command_line'

module LsPair
  class DirectoryService
    def initialize(options = {})
      @options = options
    end

    def user_exists?(username)
      users.values.include?(username)
    end

    def create_user(username)
      dscl_create = lambda { |cmd|
        command_line.run("dscl . -create /Users/#{username} #{cmd}".strip)
      }
      dscl_create['']
      dscl_create["RealName \"#{username} Pair Account\""]
      dscl_create['UserShell /bin/bash']
      dscl_create["NFSHomeDirectory /Users/#{username}"]
      dscl_create["UniqueID #{next_user_id}"]
      dscl_create["PrimaryGroupID #{staff_group_id}"]
    end

    private

    def command_line
      @options[:command_line] || CommandLine.new
    end

    def next_user_id
      users.keys.max + 1
    end

    def staff_group_id
      20
    end

    def users
      @users ||= command_line.run('dscl . -list /Users UniqueID').split("\n").inject({}) { |m, line|
        username, id = line.split(/\s+/).map(&:strip)
        m[id.to_i] = username
        m
      }
    end
  end
end
