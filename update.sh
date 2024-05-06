#!/bin/bash
# SPDX-License-Identifier: MIT
export OMBVER="0.9"
set +x # exit on errors

if [ ! -d ~/".omb" ]; then
  echo "Bash Attack is not installed."
  exit 1
fi
if [ "$EUID" = 0 ]; then
  echo "Update aborted. Type `ba version` for more info."
  echo
  exec bash
fi

# Update OMB
echo "Updating..."
git clone https://github.com/ohmybashrc/ohmybash ~/.omb-git -q
rm -rf ~/.omb
mkdir ~/.omb
cd ~/.omb-git
bash configure.sh
cd ~
cp ~/.omb-git/omb_init.sh ~/.omb/omb_init.sh
cp -r ~/.omb-git/help ~/.omb/help
cp -r ~/.omb-git/themes ~/.omb/themes
cp -r ~/.omb-git/plugins ~/.omb/plugins
rm -rf ~/.omb-git
echo "Updated!"
exec bash
