#!/bin/sh

current_dir=('pwd') 

dirlist=('ls')
hostname="user@localhost:/home/decryptdir"


Clutch2 1 #file: should be 1 if others are deleted after download and transfer

for each in "${dirlist[@]}"
do
	scp $current_dir/$each $hostname #file vm@10.000:directory
	rm $each #file
done

dirempty=('ls')

if [! -e "$dirempty"]; then
	echo "File copied and removed"
fi