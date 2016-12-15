
# Dami Orikogbo EC700 Sp '16
# Regex and Encryption

#!/bin/bash


for binFile in $(find /Users/damiOr/Desktop/binaryFilesONLY -type f)
do
	file=$(basename "$binFile")
	
	echo " Search Results for $file :aes-128-ecb"
	#echo $binFile
	strings $binFile | grep aes-128-ecb	

	echo " Search Results for $file :aes-192-ecb"
	strings $binFile | grep aes-192-ecb

	echo " Search Results for $file :aes-256-ecb"
	strings $binFile | grep aes-256-ecb




done