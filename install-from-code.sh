#!/bin/bash

if [ -z "$OMBVER" ]; then
  echo "No newcomers allowed. Please run from install.sh"
  exit 1
fi

mkdir ~/.omb
source configure.sh
cp omb_init.sh ~/.omb/
cp -r themes ~/.omb/
cp -r plugins ~/.omb/
cp -r help ~/.omb/
echo "Done!"
echo "Future updates may overwrite with the public code."
echo "To prevent this consider copying the files yourself."
echo
echo "Enjoy the shell's taste."
echo "source $HOME/.omb/omb_init.sh" >> ~/.bashrc
exec bash
