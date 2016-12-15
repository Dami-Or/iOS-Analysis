# Dami Orikogbo EC700 Sp '16
# run nm on all mach-o files in given directory
# and get symbols and libraries


#!/bin/bash

mkdir /Users/damiOr/Desktop/symbols
mkdir /Users/damiOr/Desktop/otool

wait

for binFile in $(find /Users/damiOr/Desktop/binaryFilesONLY/ -type f)
do
	file=$(basename "$binFile")
	#echo "$file"
	nm -m $binFile > /Users/damiOr/Desktop/symbols/$file.txt
	otool -L $binFile > /Users/damiOr/Desktop/otool/$file.txt
	
done


wait

scp -r Desktop/symbols/ ubuntu@128.52.187.75:/iOS/resultsAnalysis
scp -r Desktop/otool/ ubuntu@128.52.187.75:/iOS/resultsAnalysis