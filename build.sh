#!/bin/bash

# for (( i = 0; i < 17; i++ )); do echo "$(tput setaf $i)This is ($i) $(tput sgr0)"; done

function printMessage {
  color=$(tput setaf $1)
  message=$2
  reset=$(tput sgr0)
  echo -e "${color}${message}${reset}"
}

function boldMessage {
  color=$(tput setaf $1)
  message=$2
  reset=$(tput sgr0)
  echo -e "${color}*************************************${reset}"
  echo -e "${color}${message}${reset}"
  echo -e "${color}*************************************${reset}"
}

#echo -e "${color}Building Ember app${reset}"
boldMessage 4 "Building Ember app"
cd ember-app
ember build --environment production
cd ../

mv public/ public_bk/
mkdir public/

printMessage 4 "Copying ember build files to rails"
cp -r ember-app/dist/ public/

printMessage 4 "Swaping assets dir for ember-assets"
mv public/assets public/ember-assets

printMessage 4 "Replacing references s/assets/ember-assets/ in public/index.html"
sed -i .bck s/assets/ember-assets/ public/index.html

printMessage 4 "Cleaning Up"
rm -rf public_bk/
rm public/index.html.bck

boldMessage 4 "Done"
