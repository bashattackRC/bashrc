# This is NOT a general-purpose script. It is intended for the
# installer and other things intended to provide Oh My Bash.
#
# This script replaces placeholders with optioms based on the
# system's resources. Users should run omb update if this changes.
BASH_SEDIFIED=${ombBASH//\//\\/}
printf "\rAdding info to scripts... "
# Find all files in the folders "themes" and "plugins" whose name starts with "omb-"
find themes plugins -type f -name "omb-*" > ./manifest.txt
# Find all files in the folder "help" whose file name ends with ".omb-help"
find help -type f -name "*.omb-help" >> ./manifest.txt
# Add the file in the working directory called omb_init.sh
echo "omb_init.sh" >> ./manifest.txt

# Loop through the files in manifest.txt and replace placeholders
while read -r file; do
  sed -i "s/@@VERSION@@/1.1/g" "$file"
  sed -i "s/@@PROJECTNAME@@/Bash Attack/g" "$file"
  sed -i "s/@@ARCH@@/$(arch)/g" "$file"
  sed -i "s/@@BASHPATH@@/$BASH_SEDIFIED/g" "$file"
  ((placeholders_done++))
  printf "\rAdding info to scripts... [$placeholders_done]"
done < ./manifest.txt
echo
unset placeholders_done
rm ./manifest.txt
