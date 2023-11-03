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
  nice "Git" "$(git version)"
else
  error "Git" "Git is missing"
fi
if (lsb_release -a > /dev/null); then
  nice "Distro" "$(lsb_release -ds)"
else
  warning "Distro" "lsb_release is missing"
fi
