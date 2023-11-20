#!/bin/bash

if [ -z "$OMBVER" ]; then
  echo "No newcomers allowed. Please run from install.sh"
  exit 1
fi

mkdir ~/.omb
source configure.sh
cp omb_init.sh ~/.omb/
cp -r themes ~/.omb/themes
cp -r plugins ~/.omb/plugins
cp -r help ~/.omb/help
echo "Done!"
echo "Future updates may overwrite with the public code."
echo "To prevent this consider copying the files yourself."
echo
echo "Enjoy the shell's taste."
exec bash
