omb_version=0.5
BASH_SEDIFIED=${OMB_BASH_PATH//\//\\/}
printf "\rAdding info to scripts... "
while read -r file; do
  sed -i "s/@@VERSION@@/$omb_version/g" "$file"
  sed -i "s/@@PROJECTNAME@@/Oh My Bash/g" "$file"
  sed -i "s/@@VER@@/Oh My Bash/g" "$file"
  sed -i "s/@@BASHPATH@@/$BASH_SEDIFIED/g" "$file"
  ((placeholders_done++))
  printf "\rAdding info to scripts... ($placeholders_done files modded)"
done < ./manifest.txt
echo
unset placeholders_done
