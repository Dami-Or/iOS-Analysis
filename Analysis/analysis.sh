# Dami Orikogbo EC700 Sp '16
# Prep decrypted ipa files for analysis —> gather all MH_EXECUTE in one place

#!/bin/bash

echo "Making Directories"
mkdir /iOS/binaryFilesONLY
mkdir /iOS/ipaFiles
mkdir /iOS/symbols
echo "Done Making Directories"

wait

echo "Syncing Databases"
rsync -avh /Users/user/Desktop/apps ubuntu@<IP>:/iOS/apps
echo "Done Syncing Databases"

wait

echo "Unzipping ipa Files"
#unzip ipa files and move to new directory
for names in $(find /iOS/apps -type f -name "*.ipa")
do 
	file=$(basename "$names" .ipa)
	#echo "$file" >> appNames.txt
	unzip $names -d /iOS/ipaFiles/$file
	#rm $names

done

echo "Done Unzipping ipa Files"

wait

echo "Remove Spaces in ipa Filename"

#rename files with spaces to underscore(_)
find /iOS/ipaFiles -depth -name "* *" -execdir rename 's/ /_/g' "{}" \;

echo "Done Removing Spaces in ipa Filename"

wait

echo "Move App Binaries to one Directory"

# find all mach-o executable binaries and move to new directory
for binary in $(scanmacho -BRE MH_EXECUTE -F '%F' -p /iOS/ipaFiles) 
do
        file=$(basename "$binary")
        echo "$file"  >> appNames.txt
        mv "$binary" /iOS/binaryFilesONLY

done 

echo "Done Moving App Binaries to one Directory"

wait

echo "The number of ipa files: $(ls -1 /iOS/binaryFilesONLY | wc -l) "

echo "The number of ipa files: " >> appNames.txt
ls -1 /iOS/binaryFilesONLY | wc -l >> appNames.txt

wait

echo "Class-dump-z on App Binaries"

for binFile in $(find /iOS/extra/binaryFilesONLY -type f)
do
	echo $binFile
	file=$(basename "$binFile")
	class-dump-z -Nb -H $binFile -o /iOS/classDump/$file

done

echo "Done: Class-dump-z "

wait 

echo "rsync to local get symbols"

rsync -avh /iOS/binaryFilesONLY/* user@<IP>:/Users/user/Desktop/binaryFilesONLY

echo "Done synching to local"

wait 

sshpass -p 'passwd' ssh user@<IP> "cd Desktop;./symbols.sh"


   






















