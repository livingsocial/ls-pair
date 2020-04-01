require 'ls_pair/exception'

module LsPair
  class WemuxCommand
    class InvalidOption < LsPair::Exception
    end

    VALID_MODES = %w[ mirror pair rogue ]
    def set_auto_wemux_command(mode, filesystem:, home_dir:)
      mode = "pair" if mode.to_s =~ /^\s*$/

      unless VALID_MODES.include?(mode)
        raise InvalidOption, "sorry, wemux doesn't know what '#{mode}' means"
      end

      filesystem.create_file(
        "#{home_dir}/.bash_profile", # path
        "wemux #{mode} ; exit",      # content
      )
    end

  end
end
