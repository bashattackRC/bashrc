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
  	nice "Distro" "Android (Bash running under Termux)"
  	return
  fi
  if [[ -f "/etc/debian_version" ]]; then
        nice "Distro" "Debian family (Debian, Ubuntu, Kali, etc)"
        return
  fi
  if command -v pacman; then
  	nice "Distro" "Arch family (Arch, Manjaro, EndeavourOS, etc)"
  	return
  fi
  warning "Distro" "Gotta be some FBI distro or something."
}

if ! [ -d ~/".omb" ]; then
  error "Missing Bash Attack" "Bash Attack is not installed."
  exit 1
fi

echo "Sourcing bashrc... (You can trust this script)"
source ~/.bashrc

if [[ $EUID == 0 ]]; then
  warning "Root" "Root installs are unsupported"
fi

info "Bash Attack version" "$OMB_VERSION"
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
category "Plugins"
for i in $plugins; do
  echo "* $i"
done
category "Software"
if (python3 -c "print('test')" > /dev/null); then
  nice "Python 3" "Test script executed successfully"
else
  warning "Python 3" "Test script failed. Some plugins require Python"
fi
