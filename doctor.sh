warning() {
  echo -e "\e[33m[!] $1: $2\e[0m"
}

nice() {
  echo -e "\e[32m[✓] $1: $2\e[0m"
}

error() {
  echo -e "\e[31m[X] $1: $2\e[0m"
}

info() {
  echo -e "[i] $1: $2"
}

category() {
  echo "> $1"
}

distro_find() {
  if [[ $OSTYPE == "linux-android" ]]; then
  	nice "Distro" "Termux"
  	return
  fi
  if [[ -f "/etc/debian_release" ]]; then
        nice "Distro" "Debian or Ubuntu?"
        return
  fi
  if command -v pacman; then
  	nice "Distro" "Arch or Manjaro?"
  	return
  fi
  error "Distro" "Couldn't find any ways to identify distro"
}

if ! [ -d ~/".omb" ]; then
  error "Missing OMB" "Oh My Bash is not installed."
  exit 1
fi

echo "Sourcing omb_init... (You can trust this script)"
source ~/.omb/omb_init.sh

if [[ $EUID == 0 ]]; then
  warning "Root" "Root installs are unsupported"
fi

info "Oh My Bash version" "$OMB_VERSION"
info "Bash version" "$BASH_REAL_VERSION"
if (git version > /dev/null); then
  nice "Git" "$(git version) ($(type git))"
else
  error "Git" "Git is missing"
fi
if (lsb_release -a > /dev/null); then
  nice "Distro" "$(lsb_release -ds)"
else
  warning "Distro" "LSB-Release not found. Falling back to alt method"
  warning "Distro" "The results may be less accurate compared to lsb"
  distro_find
fi

info "Theme" "${theme^}"
info "Plugins" "${#plugins[@]} loaded, type omb plugin for a list"
category "Software"
if (python3 -c "print('test')" > /dev/null); then
  nice "Python 3" "Test script executed successfully"
else
  warning "Python 3" "Test script failed. Some plugins require Python"
fi
