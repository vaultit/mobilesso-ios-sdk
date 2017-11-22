#!/bin/bash

no_docs=0

for i in "$@" ; do
if [[ $i == "--skip-docs" ]] ; then
echo "Skipping docs..."
no_docs=1
break
fi
done

if [ $no_docs -eq 0 ] ; then
echo "Generating docs... this can take a while."
cp README.md MobileSSOFramework/README.md
cd MobileSSOFramework
jazzy --theme fullwidth --min-acl internal &> /dev/null
rm README.md
cd ..
fi

podspec_name="VaultITMobileSSOFramework"
destination_folder="$HOME/Documents/Libraries/$podspec_name/"

echo "Copying local Pod to $destination_folder"

rm -rf $destination_folder
ditto "MobileSSOFramework" "$destination_folder/MobileSSOFramework/"
ditto "$podspec_name.podspec" $destination_folder
