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

# Update OMB
echo "Updating..."
git clone https://github.com/TylerMS887/ohmybash ~/.omb-git -q
cp ~/.omb-git/omb_init.sh ~/.omb/omb_init.sh
rm -rf ~/.omb
mkdir ~/.omb
cp -r ~/.omb-git/themes ~/.omb/themes
cp -r ~/.omb-git/plugins ~/.omb/plugins
rm -rf ~/.omb-git
echo "Updated!"
exec bash
