#!/bin/bash
# Created by Aabhas Vineet Malik (email: aabhaas.iiser@gmail.com)
# Modified by Ankur Shringi (email: ankurshringi@iisc.ac.in)
# Last Modification date : 2018-Apr-11

# Prerequisits on Windows10 (compatibility of this code with Windows10 has not been checked)
#	Install Windows Subsystem for Linux (WSL) (https://docs.microsoft.com/en-us/windows/wsl/install-win10)
#   Open Linux terminal and type
#	sudo apt get update
#	sudo apt-get install build-essential libpoppler-cpp-dev pkg-config python-dev 
#	sudo apt-get install python-pip
#	pip install pdftotext
# 	sudo apt-get install poppler-utils

# How to use
# Open linux terminal
# cd to the desired folder (might need to use cd /mnt/c/users/... for windows)
# Copy this script to the folder which contains your pdf files.
# Change the permission of the file so that it is executable (chmod -755 sorting_script_txt.sh)
# Put following command to get further instructions on how to use it
# ./sorting_script_txt.sh

N_MAX=100 	# Number of lines to be read from the starting of the file

rm text.txt

if [ $# -eq 0 ]
then
	echo "enter keywords separated by a space"
	echo "if only one keyword is entered, a folder will be created and hardlinks of the matches will be dumbed there"
	echo "if more than one keyword is given, all matches will be displayed"
	echo "a file named text.txt will always be created giving the context in which the keywords appear in the pdf files"
elif [ $# -eq 1 ]
then
	echo "*************number of inputs is 1***************"
	echo "************hard links will be made**************"
	echo "*********case insensitive search will be carried out in the current folder*******"
	if [ -n "$(ls -d $1 2> /dev/null)" ]
	then
		echo "***********folder for $1 is available*********"
		echo "******context has been enumerated in text.txt*****"
	else
		echo "***********folder for $1 is not available*********"
		echo "********folder for $1 is being created********"
		mkdir "$1"
		echo "******context has been enumerated in text.txt*****"
	fi
else
	echo "********number of inputs is greater than 1*********"
	echo "**************files are listed below***************"
	echo "******context has been enumerated in text.txt*****"
fi

if [ $# -gt 0 ]
then
	OIFS="$IFS"
	IFS=$'\n'
	for i in $(ls *.pdf)
	do
		FLAG=0
		#echo $i
		for ((j=1; j<$#+1; j=j+1))
		do
			less $i | head -$N_MAX > .tmp.txt
			COMMAND_ONE=$(grep -in ${!j} -C 5 .tmp.txt | tee .text.txt)		#${!#} gives access to the last argument supplied to the script; ${!j} gives access to the j-th argument supplied to the script
			COMMAND_TWO=$(pdfinfo $i 2>/dev/null | grep -i ${!j})
			if [ -n "$COMMAND_ONE" ] || [ -n "$COMMAND_TWO" ]	#'-n' checks that the string is not empty. for more options see 'man test'
			then
				FLAG=1
				echo "*************************************************" >> text.txt
				echo -e 'FILE: '$i'\t\t KEYWORD'$j': '${!j} >> text.txt		# -e enables the interpretation of '\' characters
				cat .text.txt >> text.txt
				echo "*************************************************" >> text.txt
				continue
			else
				FLAG=0
				j=$(($#+1))
			fi
		done

		if [ $FLAG -eq 0 ]
		then
			continue
		fi

		if [ $# -eq 1 ]
		then
			link="$1/$i"
			if [ ! -f "$link" ]		#'[ -f "filename" ]' if "filename" exists and is a regular file
			then
				echo "Creating hardlink for file: $i"
				ln $i $link
			else
				echo "Hardlink  exists  for file: $i"
			fi
		else
			echo $i
		fi
	done
	IFS="$OIFS"
fi

rm .tmp.txt .text.txt
