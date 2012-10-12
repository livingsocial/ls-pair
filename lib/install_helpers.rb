require 'fileutils'
require 'pathname'

Pathname.class_eval do
  def blank?
    to_s =~ /^\s*$/
  end
end


module Paths
  Cache = {}

  def self.path(name, pathname)
    define_method(name) {
      pathname = Cache[name.to_sym] ||= Pathname.new(File.expand_path(pathname))
    }
    module_function name
  end

  path :root,       File.expand_path('../..', __FILE__)
  path :vimconfig,  root + 'vimconfig'

  path :home,       File.expand_path('~')
end

# Run a command, printing output a line at a time as we get it...
def run_cmd(cmd)
  IO.popen(cmd) do |data|
    while line = data.gets
      puts line
    end
  end
end

# There may be a lot of output; highlight the important bits
def announce(message, divider_char = '=')
  divider = divider_char * message.length
  puts '', divider, message, divider
end

# Make sure we have wemux
def ensure_wemux_installed
  return if `which wemux` =~ /\S+/
  announce "Installing wemux..."
  run_cmd 'brew install wemux'
end

# Symlink our tmux configuration file into the user's home directory
def symlink_tmux_conf_into_home
  tmux_conf = Paths.home + '.tmux.conf'
  if File.exist?(tmux_conf) && !File.symlink?(tmux_conf)
    announce "Unable to symlink tmux.conf into your home directory.  (Apparently you've already got one.)"
  else
    FileUtils.ln_sf Paths.root + 'tmux.conf', tmux_conf
  end
end

# Symlink the vim dotfiles, unless the user has already got one (it's very nice-uh)
def symlink_vim_dotfiles_into_home(overwrite = false)
  dot_vimrc = Paths.home + '.vimrc'
  dot_vim   = Paths.home + '.vim'
  if overwrite
    FileUtils.rm_f [dot_vimrc, dot_vim]
  end
  if File.exist?(dot_vimrc) || File.exist?(dot_vim)
    announce "You already have a .vimrc and/or .vim directory.  Skipping the part where we symlink those..."
  else
    announce "Symlinking our standard vim configuration..."
    FileUtils.ln_sf Paths.vimconfig + 'vimrc', dot_vimrc
    FileUtils.ln_sf Paths.vimconfig + 'vim',   dot_vim
  end
end

# vim plugins are in git submodules; grab 'em
def fetch_git_submodules
  announce "Fetching git submodules (this may take a few moments)..."
  run_cmd 'git submodule init'
  run_cmd 'git submodule update'
end

def toggle_vim_config
  dot_vimrc = Paths.home + '.vimrc'
  dot_vim   = Paths.home + '.vim'
  dot_vim_orig = Paths.home + ".vim.ls-pair.orig"
  dot_vimrc_orig = Paths.home + ".vimrc.ls-pair.orig"
  configs_swapped_name = Paths.home + ".vim.ls-pair.config.swapped" 

  if File.exists?(configs_swapped_name)
    announce "Reverting vim config back to original"
    FileUtils.rm configs_swapped_name, :force => true
    FileUtils.rm dot_vimrc, :force => true
    FileUtils.rm dot_vim, :force => true
    FileUtils.mv dot_vim_orig, dot_vim, :force => true
    FileUtils.mv dot_vimrc_orig, dot_vimrc, :force => true
  else
    announce "Replacing Vim configuration with the ls-pair Vim Configuration (Don't worry your config is backed up)"
    FileUtils.touch configs_swapped_name
    FileUtils.mv dot_vimrc, dot_vimrc_orig, :force => true
    FileUtils.mv dot_vim, dot_vim_orig, :force => true
    FileUtils.ln_sf Paths.vimconfig + "vim", dot_vim
    FileUtils.ln_sf Paths.vimconfig + "vimrc", dot_vimrc
  end
end
