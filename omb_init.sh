# SPDX-License-Identifier: MIT
# Loader for Oh My Bash. This is required to load plugins, themes,
# and others.

# Expose ohmybash version to BASH_VERSION
export BASH_REAL_VERSION="$BASH_VERSION"
export BASH_VERSION="$BASH_VERSION omb-0.9"
# And to a separate variable
export OMB_VERSION="0.9"

# Run commands that affect the prompt
function __OMB-INIT-PROMPTCOMMAND__ {
  for i in $PROMPT_COMMANDS; do
    command $i
  fi
}

PROMPT_COMMANDS=()

PROMPT_COMMAND="__OMB-INIT-PROMPTCOMMAND__"

# Check if the terminal is graphical by looking at the TERM and DISPLAY variables
# Used to detect if the terminal would support nerd fonts and other powerline fonts
no_xterm_check() {
  test "$TERM" != xterm* || test "$TERM" != rxvt*
}
if no_xterm_check && [[ -z "$DISPLAY" ]]; then
  # The terminal is graphical, so set XTERM_UNAVAILABLE to "no"
  XTERM_UNAVAILABLE="no"
else
  # The terminal is not graphical, so set XTERM_UNAVAILABLE to "yes"
  XTERM_UNAVAILABLE="yes"
  PROMPT_COMMANDS+=('echo -ne "\033]0;$XTERM_TITLE_BEGINNING${USER}@${HOSTNAME}: ${PWD}\007"')
fi

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
   return 127
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

# Create omb function
omb() {
  if [[ "$1" == "" ]]; then
    echo 'This function allows you to configure Oh My Bash,
enable plugins, choose themes, and more.
--- Usage ---------------------------------------
  omb command [element tool]

--- Commands ------------------------------------
  Utilities
    plugin    Manage plugins
    theme     Manage themes
    update    Update Oh My Bash
    reload    Re-execute bash
    edit      Edit .bashrc

  About
    help      Read help pages
    web       Visit Oh My Bash on the web
    version   Echo current version

--- Tools ---------------------------------------
  plugin
    enable   Enable a plugin
    disable  Disable a plugin

  theme
    enable   Enable a theme

  help accepts the name of a help document.

  update, reload, edit, web and version have no tools.'  | more
    return
  fi

  if [[ "$1" == "plugin" ]]; then
    if [[ "$3" == "enable" ]]; then
      echo "Enabling plugin $2"
    elif [[ "$3" == "disable" ]]; then
      echo "Disabling plugin $2"
    else
      echo "${#plugins[@]} plugins enabled. Here is a list of them."
      echo "You can always enable plugins using omb plugin [name] enable"
      echo "and disable using omb plugin [name] disable."
      echo
      # define the number of columns for the grid
      cols=6
      
      # loop through the array and print each element with padding
      for ((i=0; i<${#plugins[@]}; i++)); do
        printf "%-10s" "${plugins[i]^}"
        # add a newline after every cols elements
        if (( (i+1) % cols == 0 )); then
          echo
        fi
      done
      
      # add a final newline if the last row is not complete
      if (( ${#plugins[@]} % cols != 0 )); then
        echo
      fi
    fi
  elif [[ "$1" == "theme" ]]; then
    if [[ "$3" == "enable" ]]; then
      if [ ! -f ~/".omb/themes/omb-$2" ]; then
        echo "Theme `$2` does not exist"
        return 1
      fi
      sed -i 's/export theme="'$theme'"/export theme="'$2'"/g' ~/.bashrc
      export theme="$2"
      refresh_theme
      echo "Theme $2 has been enabled in your bashrc"
    else
      echo "Current theme: $theme"
      echo "To change this use:"
      echo "  omb theme [new_theme] enable"
    fi
  elif [[ "$1" == "update" ]]; then
      if [ "$EUID" = 0 ]; then
        echo "Oh My Bash doesn't support installs on root. This means"
        echo "you cannot update it. Please consider uninstalling Oh My"
        echo "Bash, then install it again as a normal user."
        echo
        echo "Update canceled."
        return
      fi
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
                        |___/                         \e]8;;\a"
      echo "$OMB_VERSION on $BASH_REAL_VERSION"
      echo -e "Licensed under the \e]8;;https://opensource.org/license/mit/\aMIT License\e]8;;\a"
      echo "User: $(id -un)@$(hostname)"
      echo "Path to bash: $BASH"
      if [ "$EUID" = 0 ]; then
        echo
        echo "Oh My Bash doesn't support installs on root. This means"
        echo "you cannot update it. Please consider uninstalling Oh My"
        echo "Bash, then install it again as a normal user."
      fi
  elif [[ "$1" == "reload" ]]; then
      exec bash
  elif [[ "$1" == "help" ]]; then
      if [ -z "$2" ]; then
        echo "Please specify a document (e.g. omb help omb):"
        ls ~/.omb/help --color=none
        return
      fi
      less ~/.omb/help/$2.omb-help
  elif [[ "$1" == "web" ]]; then
      xdg-open "https://ohmybashrc.github.io"
  elif [[ "$1" == "doctor" ]]; then
      if [ ! -f ~/".omb/doctor.sh" ]; then
         echo "This will download a script from the OMB repos."
         echo "The script may not support older versions of OMB."
         echo "Updates will delete this script as it is stored internally."
         echo -n "Continue? (Y/n) "
         read -n 1 y
         echo
         if [[ $y == "y" ]] || [[ $y == "" ]]; then
           curl -fSL https://raw.githubusercontent.com/TylerMS887/ohmybash/main/doctor.sh -o ~/.omb/doctor.sh
         else
           return
         fi
       fi
       bash ~/.omb/doctor.sh
  else
      echo "Invalid command"
  fi
}
