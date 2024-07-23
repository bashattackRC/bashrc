#!/bin/bash
# SPDX-License-Identifier: MIT
if [ -z "$BASH" ]; then
  echo
  echo "It's called BASH attack. Please do not make a frankenstein setup."
  echo "Forwarding the script to compatible bash shell."
  echo
  bash install.sh
  exit $?
fi

export OMBVER="0.9"
set +x # exit on errors
if [ "$EUID" = 0 ] && [ "$ALLOW_SUDO_INSTALL" != 1 ]; then
  echo
  echo "  Don't install this script as root! Using root account"
  echo "  can expose malicious 3rd-party plugins to your full"
  echo "  file system."
  echo
  echo "  If you are REALLY SURE you want to do this, prepend"
  echo "  this to the beginning of the install command:"
  echo "    ALLOW_SUDO_INSTALL=1"
  echo
  echo "  Please note you will not get any updates. Good luck"
  echo "  getting hacked"
  echo
  exec bash
fi

# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}
function select_opt {
    select_option "$@" 1>&2
    local result=$?
    echo $result
    return $result
}

# Print info about forcing root
if [ "$EUID" = 0 ] && [ "$ALLOW_SUDO_INSTALL" = 1 ]; then
  echo
  echo "  Don't install as root! Using root account"
  echo "  can expose malicious 3rd-party plugins to your full"
  echo "  file system. You have chosen to install OMB anyways."
  echo "  Is this true? Select '5' to continue"
  echo
  options=("1" "2" "3" "4" "5" "6" "7")
  case `select_opt "${options[@]}"` in
      4) true;;
      *) exec bash;;
  esac
fi

function switchtobash {
  # Print info about shell change
  echo "We are going to change your main shell to bash."
  echo "Enter your credentials if you are asked to do so."
  
  # Do it now
  sudo chsh $USER --shell $ombBASH
  echo "Your default shell is now bash!"
  echo
}

echo "Bash seems to be located at $BASH, but if this is incorrect"
echo "you can specify a different path here. Else, press enter."
echo "If you are unsure, please press enter without touching anything"
echo "else you might end up breaking your setup."
echo
echo "Path to bash:"
read -e -i "$BASH" ombBASH
echo
# Check if the current shell is bash
if [ "$SHELL" != "$ombBASH" ]; then
    echo
    echo "You probably want to use a Bash shell, but"
    echo "your default shell is set to $(basename $SHELL)."
    echo
    echo "This probably means you are either installing Bash Attack"
    echo "on an arbritary system that does not come with bash,"
    echo "or used another shell package to use other customizations"
    echo "such as Oh My Zsh."
    echo
    echo "There are many ways of switching to Bash."
    echo "The recommended way is using chsh. You can do this now."
    echo
    options=("Chsh now" "Keep previous shell")
    case `select_opt "${options[@]}"` in
        0) switchtobash;;
        *) true;;
    esac
fi


# Info about bashrc
if [ -f ~/".bashrc" ]; then
   echo "This script is going to create a new bashrc file."
   echo "Your previous one will be moved to the following path:"
   echo "   $HOME/.bashrc.omb-backup"
   echo "You can copy any lines from there."
   mv ~/.bashrc ~/.bashrc.omb-backup -f
fi
echo -e "# Generated by Oh My Bash $OMBVER\n" > ~/.bashrc
echo

# Info about plugins
echo "The git plugin will be enabled by default."
echo "The entoli theme will be used by default."
echo "More plugins can be enabled by editing .bashrc."
echo '# Plugins. git is enabled by default.' >> ~/.bashrc
echo '# Names are separated by whitespace, not commas.' >> ~/.bashrc
echo 'export plugins=("git")' >> ~/.bashrc
echo '' >> ~/.bashrc #Newline in bashrc

echo 'export theme="entoli"' >> ~/.bashrc
echo

# Install OMB
if [ -d ".git" ] && [ -f ".proof_that_this_is_omb_git" ]; then
    echo "This seems to be a local copy of the source code."
    echo "This guess has been made because you have a file with the long name"
    echo ".proof_that_this_is_omb_git and a folder called .git."
    echo
    echo "This could be a modified version of some sorts. You may want"
    echo "to install the scripts from source code instead of the web."
    echo "Where do you want to install?"
    echo
    options=("From my source code" "From the web")
    case `select_opt "${options[@]}"` in
        0) exec bash install-from-code.sh;;
        *) true;;
    esac
fi
echo "Cloning..."
git clone https://github.com/ohmybashrc/ohmybash ~/.omb-git -q --branch main
echo "Preparing scripts..."
cd ~/.omb-git
export ombBASH
echo "export ombBASH='$ombBASH'" >> ~/.bashrc
bash configure.sh
cd ~
echo "Copying..."
mkdir ~/.omb
cp -r ~/.omb-git/help ~/.omb/help
cp -r ~/.omb-git/themes ~/.omb/themes
cp -r ~/.omb-git/plugins ~/.omb/plugins
cp ~/.omb-git/omb_init.sh ~/.omb/omb_init.sh
echo >> ~/.bashrc
echo "source $HOME/.omb/omb_init.sh" >> ~/.bashrc
rm -rf ~/.omb-git
echo "Installed! Hit any key to use your customised bash shell:"
read -s -n 1
exec bash
