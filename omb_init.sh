# Define dummy git trap in case git plugin is disabled.
# git plugin can redefine the function

function _git-plugin-trap {}

# Define Functions for Extensions
function refresh_theme() {
   source ~/.omb/themes/omb-$theme
}

# Load Plugins
for i in ${plugins[@]}; do
   source ~/.omb/plugins/omb-$i
done

# Load Theme
source ~/.omb/themes/omb-$theme

# Add "omb" Pseudo-Program
omb() {
  if [[ "$1" == "" ]]; then
    echo "Usage: omb [plugin|theme|update] [enable|list] [name]"
    echo ""
    echo "Commands:"
    echo "  plugin  Manage plugins"
    echo "  theme   Manage themes"
    echo "  update  Update omb"
    echo ""
    echo "Options:"
    echo "  plugin:"
    echo "    enable   Enable a plugin"
    echo "    disable  Disable a plugin"
    echo "    list     List all plugins"
    echo ""
    echo "  theme:"
    echo "    enable   Enable a theme"
    echo "    list     List all themes"
    echo ""
    return
  fi

  if [[ "$1" == "plugin" ]]; then
    if [[ "$2" == "enable" ]]; then
      echo "Enabling plugin $3"
    elif [[ "$2" == "disable" ]]; then
      echo "Disabling plugin $3"
    elif [[ "$2" == "list" ]]; then
      echo "Listing plugins"
    else
      echo "Invalid option for plugin command"
    fi
  elif [[ "$1" == "theme" ]]; then
    if [[ "$2" == "enable" ]]; then
      echo "Enabling theme $3"
    elif [[ "$2" == "list" ]]; then
      echo "Listing themes"
    else
      echo "Invalid option for theme command"
    fi
  elif [[ "$1" == "update" ]]; then
      exec bash -c "$(curl -fsSL https://raw.githubusercontent.com/TylerMS887/ohmybash/main/update.sh)"
  else
      echo "Invalid command"
  fi
}
