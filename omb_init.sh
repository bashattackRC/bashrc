# SPDX-License-Identifier: MIT
# Loader for Bash Attack. This is required to load plugins, themes, and others.
# FOR USERS:
# Do not edit this script. Customizations in it will be overwritten by updates,
# and you are also able to edit .bashrc to add customizations there.
# FOR GITHUB DEVELOPERS:
# When this script is edited. EVERYTHING will be changed for everyone who updates
# to the new version. Don't add softlocks, rm commands, or other traps here.
# Don't add integrations, integrations should be made as plugins.
# Don't add PROMPT_COMMANDS in omb_init, because those are for helping
# plugins and themes adapt to the prompt.

# Exit if this isn't bash
if [ -z "$BASH" ]; then
  echo
  echo "Please do not make a frankenstein setup."
  echo "Bash Attack contains syntax incompatible with POSIX and thus several foreign shells."
  echo "Cancelling init. Consider changing your shell to bash."
  return
fi

# Expose ohmybash version to BASH_VERSION
export BASH_REAL_VERSION="$BASH_VERSION"
export BASH_VERSION="$BASH_VERSION omb-@@VERSION@@"
# And to a separate variable
export OMB_VERSION="@@VERSION@@"

# Run commands that affect the prompt
function _promptcommand {
  for i in $PROMPT_COMMANDS; do
    $i
  done
}

PROMPT_COMMANDS=()

PROMPT_COMMAND='_promptcommand; echo -ne "\033]0;${XTERM_TITLE_BEGINNING}$(basename ${PWD})\007"'

# Find the right editor to use
function edit-file {
  editor $@ || \
  micro  $@ || \
  vim    $@ || \
  emacs  $@ || \
  nano   $@ || \
  vi     $@ || \
  echo "No editor found. Please install one."
}

# Check if the terminal is graphical by looking at the TERM and DISPLAY variables
# Used to detect if the terminal would support nerd fonts and other powerline fonts
no_xterm_check() {
  test "$TERM" == xterm* || test "$TERM" == rxvt*
}
if no_xterm_check || [[ -z "$DISPLAY" ]]; then
  # The terminal is graphical, so set XTERM_UNAVAILABLE to "no"
  XTERM_UNAVAILABLE="no"
else
  # The terminal is not graphical, so set XTERM_UNAVAILABLE to "yes"
  XTERM_UNAVAILABLE="yes"
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
   echo -e "\033[0;31m$1: command not found\033[0m"
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

# Create ba function
ba() {
  if [[ "$1" == "" ]]; then
    echo 'This function allows you to configure Bash Attack,
enable plugins, choose themes, and more.
--- Usage ---------------------------------------
  ba command [element tool]
--- Commands ------------------------------------
  Utilities
    plugin    Enable and disable plugins.
    
    theme     Change themes and get the current one.
    
    update    Update to the newest version.
    
    reload    Replace the current bash session with another.
    
    edit      Edit the bashrc file.
    
  Troubleshooting
    doctor    Trouble-shoot issues with ba.
    
    issueinf  Generate information that must be provided in bug reports.
    
  About
    help      Read help pages.
    
    web       Visit our website.
    
    version   Echo current version. ($OMB_VERSION)
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
      echo "You can always enable plugins using ba plugin [name] enable"
      echo "and disable using ba plugin [name] disable."
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
        echo "Can't update as root."
        return
      fi
      exec bash -c "$(curl -fsSL https://raw.githubusercontent.com/TylerMS887/ohmybash/main/update.sh)"
  elif [[ "$1" == "edit" ]]; then
      edit-file ~/.bashrc && exec bash
  elif [[ "$1" == "version" ]]; then
      echo "@@VERSION@@ on $BASH_REAL_VERSION"
      echo -e "Licensed under the \e]8;;https://opensource.org/license/mit/\aMIT License\e]8;;\a"
      echo "User: $(id -un)@$(hostname)"
      echo "Path to bash: @@BASHPATH@@"
      if [ "$EUID" = 0 ]; then
        echo
        echo "Bash Attack doesn't support installs on root. This means"
        echo "you cannot update it. Consider installing as non-root."
      fi
  elif [[ "$1" == "reload" ]]; then
      exec bash
  elif [[ "$1" == "help" ]]; then
      if [ -z "$2" ]; then
        echo "Please specify a document (e.g. omb help omb):"
        ls -g ~/.omb/help | sed -e 's/\.omb-help$//'
        return
      fi
      nano --view ~/.omb/help/$2.omb-help || less ~/.omb/help/$2.omb-help || more ~/.omb/help/$2.omb-help || cat ~/.omb/help/$2.omb-help 
  elif [[ "$1" == "web" ]]; then
      xdg-open "https://ohmybashrc.github.io" || wslview "https://ohmybashrc.github.io"
  elif [[ "$1" == "doctor" ]]; then
      if [ ! -f ~/".omb/doctor.sh" ]; then
         echo "This will download a script from the repos."
         echo "Updates will delete this script as it is stored internally."
         echo -n "Continue? (Y/n) "
         read -n 1 y
         echo
         if [[ $y == "y" ]] || [[ $y == "" ]]; then
           curl -fSL https://raw.githubusercontent.com/bashattackRC/bashrc/main/doctor.sh -o ~/.omb/doctor.sh
         else
           return
         fi
       fi
       bash ~/.omb/doctor.sh
  else
      echo "Invalid command"
  fi
}

# Change old omb command to ba
alias omb="ba"
