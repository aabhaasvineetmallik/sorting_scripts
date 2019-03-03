#!/bin/bash
# Created by Aabhas Vineet Malik (email: aabhaas.iiser@gmail.com)
# Modified by Ankur Shringi (email: ankurshringi@iisc.ac.in)
# Last Modification date : 2019-Feb-03 (Making readable html output)

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
# Change the permission of the file so that it is executable (chmod -755 sorting_script_html.sh)
# Put following command to get further instructions on how to use it
# ./sorting_script_html.sh <keyword>

N_MAX=100 	# Number of lines to be read from the starting of the file

file="$@.html"
echo $file
rm $file
echo "<!DOCTYPE html>" >> $file
echo "<html>" >> $file
echo "<head>" >> $file
echo '<script src="toc.js" type="text/javascript"></script>' >> $file
echo "</head>" >> $file
echo "<title> Sorting Script</title>" >> $file
echo '<body onload="generateTOC(document.getElementById(`toc`));">' >> $file
echo '<div id="toc"></div>' >>$file
if [ $# -eq 0 ]
then
	echo "enter keywords separated by a space"
	echo "if only one keyword is entered, a folder will be created and hardlinks of the matches will be dumbed there"
	echo "if more than one keyword is given, all matches will be displayed"
	echo "a file named $file will always be created giving the context in which the keywords appear in the pdf files"
elif [ $# -eq 1 ]
then
	echo "*************number of inputs is 1***************"
	echo "************hard links will be made**************"
	echo "*********case insensitive search will be carried out in the current folder*******"
	if [ -n "$(ls -d $1 2>/dev/null)" ]
	then
		echo "***********folder for $1 is available*********"
		echo "******context has been enumerated in $file*****"
	else
		echo "***********folder for $1 is not available*********"
		echo "********folder for $1 is being created********"
		mkdir "$1"
		echo "******context has been enumerated in $file*****"
	fi
else
	echo "********number of inputs is greater than 1*********"
	echo "**************files are listed below***************"
	echo "******context has been enumerated in $file*****"
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
			COMMAND_ONE=$(grep -in ${!j} -C 5 .tmp.txt | tee .text.txt)		#${!#} gives access to the last argument supplied to the script
			COMMAND_TWO=$(pdfinfo $i 2>/dev/null | grep -i ${!j})
			if [ -n "$COMMAND_ONE" ] || [ -n "$COMMAND_TWO" ]	#'-n' checks that the string is not empty. for more options see 'man test'
			then
				FLAG=1
				echo '<h2 id = "'$i'">' >> $file
				echo -e $i '</h2>' >> $file
				echo '<a href="#toc">Go back to the table of contents!</a>' >> $file
				echo '<pre>' >> $file 
				echo '<br>KEYWORD '$j': '${!j} >> $file		# -e enables the interpretation of '\' characters
				sed -i -e ':a' -e 'N' -e '$!ba' -e 's/\n/<br>/g' .text.txt #Replacing new line character with <br>
				sed -i -e "s/${!j}/<mark>${!j}<\\/mark>/g" .text.txt #Highlighting the keyword wherever it is appearing
				cat .text.txt >> $file
				echo "</pre>" >> $file
				
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
echo "</body>" >> $file
echo "</html>" >> $file