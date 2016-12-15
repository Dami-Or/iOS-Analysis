


# Dami Orikogbo EC700 Sp '16
# Regex, keys, Encryption vuls

#!/bin/bash


apps=0

for vulns in MD4 MD5 SHA1 DES RC4 ECB CBC PBE OAEP UAObfuscatedString _obfuscated const 3des secret aes-128-ecb aes-192-ecb aes-256-ecb NSFileProtectionNone NSFileProtectionNone
do
	
	vul=0

	for binFile in $(find /Users/damiOr/Desktop/binaryFilesONLY -type f)
	do
		apps=$(($apps + 1))
		file=$(basename "$binFile")
		echo >>  /Users/damiOr/Desktop/vulnMain/$file.txt
		if strings $binFile | grep -q -i $vulns; then
			echo " [ $vulns ]: found in $file " >>  /Users/damiOr/Desktop/vulnMain/$file.txt
			echo >>  /Users/damiOr/Desktop/vulnMain/$file.txt
			strings $binFile | grep $vulns >>  /Users/damiOr/Desktop/vulnMain/$file.txt
			echo >>  /Users/damiOr/Desktop/vulnMain/$file.txt
			echo >>  /Users/damiOr/Desktop/vulnMain/$file.txt
			vul=$(($vul + 1))
		else
			:
		fi

	done
	
	echo " There are $vul /$apps  Apps with $vulns in source Code " >> /Users/damiOr/Desktop/Results.txt
	
	apps=0
done




