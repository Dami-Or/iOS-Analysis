#!/bin/bash

mkdir txt
for filename in *; do
	    nm "$filename" > "$filename".txt
	    python internal. 
	    
	   

	    mv "$filename".txt ./txt
	    
done
cd txt
rm txt.txt
rm autosym.sh.txt
rm internal.py.txt

cd ..
