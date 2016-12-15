# Dami Orikogbo EC700 Sp '16
# find execuatble mach-o file and moves all to new directory

#!/bin/bash

#rename files with spaces to underscore(_)
find /iOS/ipaFiles -depth -name "* *" -execdir rename 's/ /_/g' "{}" \;

wait


# find all mach-o executable binaries and move to new directory
for binary in $(scanmacho -BRE MH_EXECUTE -F '%F' -p /iOS/ipaFiles) 
do
        file=$(basename "$binary")
        echo "$file"  >> apps.txt
        mv "$binary" /iOS/binaryFilesONLY

done 

