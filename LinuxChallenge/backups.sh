#!/bin/bash
<<info
This script is for taking backup 
info

destination=$1

currentdate=$(date "+%Y-%d-%m_%H-%M-%S")

# count all number of backup zipped files
count=$(ls | grep "backup_" | wc | awk {'print $1'})
# If there are already 3 files extract the older and remove it and create new file else just create new zipped file
if [ $count -eq 3 ]; then 
        sortedlist=$(ls | grep "backup_" | sort | head -1)
	rm $sortedlist
	zip -r "backup_$currentdate.zip" $destination > /dev/null

else
	zip -r "backup_$currentdate.zip" $destination > /dev/null
fi
