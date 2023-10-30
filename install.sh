#!/bin/bash
# SPDX-License-Identifier: MIT
export OMBVER="0.9"
set +x # exit on errors

# Clear the console to clean everything
clear

# Go back to bash on Ctrl+C
function exec_to_bash {
  exec bash
}
trap exec_to_bash SIGINT

# Echo the project name
echo -n '''
 ██████╗ ██╗  ██╗    ███╗   ███╗██╗   ██╗    ██████╗  █████╗ ███████╗██╗  ██╗
██╔═══██╗██║  ██║    ████╗ ████║╚██╗ ██╔╝    ██╔══██╗██╔══██╗██╔════╝██║  ██║
██║   ██║███████║    ██╔████╔██║ ╚████╔╝     ██████╔╝███████║███████╗███████║
██║   ██║██╔══██║    ██║╚██╔╝██║  ╚██╔╝      ██╔══██╗██╔══██║╚════██║██╔══██║
╚██████╔╝██║  ██║    ██║ ╚═╝ ██║   ██║       ██████╔╝██║  ██║███████║██║  ██║
 ╚═════╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝   ╚═╝       ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
    Version '''; echo -n "$OMBVER"; echo -e '                      \e]8;;http://github.com/ohmybashrc/ohmybash\aGitHub...\e]8;;\a'  
# Print info about shell change
echo "We are going to change your main shell to bash so OMB can function."
echo "Enter your password if you are asked to do so."
echo -e "\e[0;36mPress Enter to do this now...\e[0m (Ctrl+C to cancel install)"
read -s # waits until enter pressed

# Do it now
sudo chsh $USER --shell /bin/bash
echo "Your default shell is now bash!"
echo

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
echo "Installing..."
git clone https://github.com/ohmybashrc/ohmybash ~/.omb-git -q
mkdir ~/.omb
cp -r ~/.omb-git/help ~/.omb/help
cp -r ~/.omb-git/themes ~/.omb/themes
cp -r ~/.omb-git/plugins ~/.omb/plugins
cp ~/.omb-git/omb_init.sh ~/.omb/omb_init.sh
echo >> ~/.bashrc
echo "source $HOME/.omb/omb_init.sh" >> ~/.bashrc
rm -rf ~/.omb-git
echo "Installed!"
exec_to_bash
