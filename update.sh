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
if [ ! -d ~/".omb" ]; then
  echo "Oh My Bash is not installed."
  exit 1
fi
if [ "$EUID" = 0 ]; then
  echo "Oh My Bash doesn't support installs on root. This means"
  echo "you cannot update it. Please consider uninstalling Oh My"
  echo "Bash, then install it again as a normal user."
  echo
  echo "Update aborted."
  echo
  exec bash
fi

# Update OMB
echo "Updating..."
git clone https://github.com/ohmybashrc/ohmybash ~/.omb-git -q
rm -rf ~/.omb
mkdir ~/.omb
cp ~/.omb-git/omb_init.sh ~/.omb/omb_init.sh
cp -r ~/.omb-git/help ~/.omb/help
cp -r ~/.omb-git/themes ~/.omb/themes
cp -r ~/.omb-git/plugins ~/.omb/plugins
rm -rf ~/.omb-git
echo "Updated!"
exec bash
