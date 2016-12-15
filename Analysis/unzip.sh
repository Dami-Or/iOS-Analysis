# Dami Orikogbo EC700 Sp '16


#!/bin/bash

for names in $(find /iOS/apps -type f -name "*.ipa")
do 
        file=$(basename "$names" .ipa)
        echo "$file" >> appNames.txt
        unzip $names -d /iOS/ipaFiles/$file


done

wait

echo "The number of ipa files: " >> appNames.txt
ls -1 | wc -l >> appNames.txt

