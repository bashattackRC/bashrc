#!/bin/bash
# SPDX-License-Identifier: MIT
export OMBVER="0.9"
set +x # exit on errors

# Clear the console to clean everything
clear

# Echo the project name
echo -n '''
 ██████╗ ██╗  ██╗    ███╗   ███╗██╗   ██╗    ██████╗  █████╗ ███████╗██╗  ██╗
██╔═══██╗██║  ██║    ████╗ ████║╚██╗ ██╔╝    ██╔══██╗██╔══██╗██╔════╝██║  ██║
██║   ██║███████║    ██╔████╔██║ ╚████╔╝     ██████╔╝███████║███████╗███████║
██║   ██║██╔══██║    ██║╚██╔╝██║  ╚██╔╝      ██╔══██╗██╔══██║╚════██║██╔══██║
╚██████╔╝██║  ██║    ██║ ╚═╝ ██║   ██║       ██████╔╝██║  ██║███████║██║  ██║
 ╚═════╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝   ╚═╝       ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
    Version '''; echo "$OMBVER"

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
if [ -f "~/.bashrc" ]; then
   echo "This script is going to create a new bashrc file."
   echo "Your previous one will be moved to the following path:"
   echo "   $HOME/.bashrc.omb-backup"
   echo "You can copy any lines from there."
   mv ~/.bashrc ~/.bashrc.omb-backup -f
   echo -e "# Generated by Oh My Bash $OMBVER\n" > ~/.bashrc
fi
echo

# Info about plugins
echo "The git plugin will be enabled by default."
echo "The simpleansi theme will be used by default."
echo "More plugins can be enabled by editing .bashrc."
echo '# Plugins. git is enabled by default.' >> ~/.bashrc
echo '# Names are separated by whitespace, not commas.' >> ~/.bashrc
echo 'export plugins=("git")' >> ~/.bashrc
echo '' >> ~/.bashrc #Newline in bashrc

echo 'export theme="simpleansi"' >> ~/.bashrc
echo

# Install OMB
echo "Installing..."
git clone https://github.com/TylerMS887/ohmybash ~/.omb-git -q
cat ~/.ohmybash-git-folder/omb_init.sh >> ~/.bashrc
mkdir ~/.omb
cp -r ~/.omb-git/themes ~/.omb/themes
cp -r ~/.omb-git/plugins ~/.omb/plugins
rm -rf ~/.omb-git
echo "Installed! Type the following command to use Oh My Bash:"
echo "   exec /bin/bash"
