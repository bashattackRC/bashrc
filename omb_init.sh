# Expose ohmybash version to BASH_VERSION
export BASH_REAL_VERSION="$BASH_VERSION"
export BASH_VERSION="$BASH_VERSION omb-0.9"
# And to a separate variable
export OMB_VERSION="0.9"

# Define dummy git trap in case git plugin is disabled.
# git plugin can redefine the function
_git-plugin-trap() {
     echo -n
}

# Append to bash history, instead of overwriting
shopt -s histappend

# Define Functions for Extensions
function refresh_theme() {
   source ~/.omb/themes/omb-$theme
}

# Define Not Found Handler
function command_not_found_handle {
   echo -e "\033[0;31m$1 is not recognized as a program, alias, or command.\n\
Perhaps you need to enable a plugin (omb plugin enable) or install software.\033[0m"
}

# Color ls and grep
alias ls="ls --color=auto"
alias grep="grep --color=auto"

# Load Plugins
for i in ${plugins[@]}; do
   source ~/.omb/plugins/omb-$i
done

# Load Theme
source ~/.omb/themes/omb-$theme

# Add "omb" Pseudo-Program
omb() {
  if [[ "$1" == "" ]]; then
    echo "Usage: omb [plugin|theme|update|reload|bashrc] [[en|dis]able|list] [name]"
    echo ""
    echo "This is a program to manage Oh My Bash. This is not a real"
    echo "program, but a simple bash function."
    echo ""
    echo "Commands:"
    echo "  plugin    Manage plugins"
    echo "  theme     Manage themes"
    echo "  update    Update Oh My Bash"
    echo "  reload    Re-execute bash"
    echo "  edit      Edit .bashrc"
    echo "  version   Echo current version"
    echo ""
    echo "Options:"
    echo "  plugin:"
    echo "    enable   Enable a plugin"
    echo "    disable  Disable a plugin"
    echo "    list     List all plugins"
    echo ""
    echo "  theme:"
    echo "    enable   Enable a theme"
    echo "    list     List all themes"
    echo ""
    return
  fi

  if [[ "$1" == "plugin" ]]; then
    if [[ "$2" == "enable" ]]; then
      echo "Enabling plugin $3"
    elif [[ "$2" == "disable" ]]; then
      echo "Disabling plugin $3"
    elif [[ "$2" == "list" ]]; then
      echo "Listing plugins"
    else
      echo "Invalid option for plugin command"
    fi
  elif [[ "$1" == "theme" ]]; then
    if [[ "$2" == "enable" ]]; then
      if [ ! -f ~/".omb/themes/omb-$3" ]; then
        echo "$3 is not a valid theme"
        return 1
      fi
      sed -i 's/export theme="'$theme'"/export theme="'$3'"/g' ~/.bashrc
      export theme="$3"
      refresh_theme
      echo "Theme $3 has been enabled in your bashrc"
    elif [[ "$2" == "list" ]]; then
      echo "Listing themes"
    else
      echo "Invalid option for theme command"
    fi
  elif [[ "$1" == "update" ]]; then
      exec bash -c "$(curl -fsSL https://raw.githubusercontent.com/TylerMS887/ohmybash/main/update.sh)"
  elif [[ "$1" == "edit" ]]; then
      nano ~/.bashrc && exec bash
  elif [[ "$1" == "version" ]]; then
      echo -e "\e]8;;https://github.com/ohmybashrc/ohmybash/\a   ____  _       __  __         ____            _     
  / __ \\| |     |  \\/  |       |  _ \\          | |    
 | |  | | |__   | \\  / |_   _  | |_) | __ _ ___| |__  
 | |  | | '_ \\  | |\\/| | | | | |  _ < / _\` / __| '_ \\ 
 | |__| | | | | | |  | | |_| | | |_) | (_| \\__ \\ | | |
  \\____/|_| |_| |_|  |_|\\__, | |____/ \\__,_|___/_| |_|
                         __/ |                        
                        |___/                       \e]8;;\a"
      echo "$OMB_VERSION on $BASH_REAL_VERSION"
      echo -e "Licensed under the \e]8;;https://opensource.org/license/mit/\aMIT License\e]8;;\a"
      echo "User: $(id -un)@$(hostname)"
      echo "Path to bash: $BASH"
  elif [[ "$1" == "reload" ]]; then
      exec bash
  else
      echo "Invalid command"
  fi
}
