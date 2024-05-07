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
git clone https://github.com/bashattackRC/bashrc ~/.omb-git
rm -rf ~/.omb
mkdir ~/.omb
cd ~/.omb-git
bash configure.sh
cd ~
cp ~/.omb-git/omb_init.sh ~/.omb/omb_init.sh -v
cp -r ~/.omb-git/help ~/.omb/help -v
cp -r ~/.omb-git/themes ~/.omb/themes -v
cp -r ~/.omb-git/plugins ~/.omb/plugins -v
rm -rf ~/.omb-git -v
echo "Updated!"
exec bash
