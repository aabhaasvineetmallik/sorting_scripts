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
#echo "$file"
folder="${PWD##*/}"
rm "$file"
echo "<!DOCTYPE html>" >> "$file"
echo "<html>" >> "$file"
echo "<head>" >> "$file"
echo "<title>"$@"</title>" >> "$file"
echo "<meta name='viewport' content='width=device-width, initial-scale=1'/>" >> "$file"
echo '<script type="text/javascript">' >> "$file"
cat "toc.js" >> "$file"
echo '</script>' >> "$file"
echo "</head>" >> "$file"
echo '<body onload="generateTOC(document.getElementById(`toc`));">' >> "$file"
echo '<div id="toc"></div>' >>"$file"
if [ $# -eq 0 ]
then
	echo "enter keywords separated by a space"
	echo "if more than one keyword is given, all matches will be displayed"
	echo 'If you want to search for a phrase put it in quotes Ex. "Quantum Computing"'
	echo "a file will always be created giving the context in which the keywords appear in the pdf files"
elif [ $# -eq 1 ]
then
	echo "The number of inputs keywords is: 1"
	echo "A case insensitive search will be carried out in first '"$N_MAX"' words of the pdfs."
	echo "  (Change the number of words to search by changing 'N_MAX' parameter in the script)"
	echo "Results are being segregated in the file: '"$file"'"
else
	echo "The number of inputs keywords is: "$# ""
	echo "A case insensitive search will be carried out in first '"$N_MAX"' words of the pdfs."
	echo "  (Change the number of words to search by changing 'N_MAX' parameter in the script)"
	echo "Results are being segregated in the file: '"$file"';"
	echo "  (Results from first keyword will appear first, followed by the rest. Scroll down to see other keywords.)"
fi
echo
# progress bar function
prog(){
    local w=80 p=$1;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /.};
    # print those dots on a fixed-width space plus the percentage etc.
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*";
}
if [ $# -gt 0 ]
then
	OIFS="$IFS"
	IFS=$'\n'
	count="$(ls 2>/dev/null -Ubad1 -- *.pdf | wc -l)" # Total number of pdfs in the current folder
	f=1
	for i in $(ls *.pdf)
	do
		prog "$(($(($f*100))/$count))" "Progress" # Displaying percentage progress (number of pdfs scanned)
		f=$(($f+1))
		FLAG=0
		for ((j=1; j<$#+1; j=j+1))
		do
			less $i | head -$N_MAX > ".$file.tmp.txt"
			COMMAND_ONE=$(grep -in ${!j} -C 5 ".$file.tmp.txt" | tee ".$file.text.txt")		#${!#} gives access to the last argument supplied to the script
			COMMAND_TWO=$(pdfinfo $i 2>/dev/null | grep -i ${!j})
			if [ -n "$COMMAND_ONE" ] || [ -n "$COMMAND_TWO" ]	#'-n' checks that the string is not empty. for more options see 'man test'
			then
				FLAG=1
				echo '<h2 id = "'$i'">' >> "$file"
				echo -e '<a href = "../'$folder'/'$i '" target = "_blank">' $i'</a></h2>' >> "$file"
				echo '<a href="#toc">Go back to the table of contents!</a>' >> "$file"
				echo '<pre>' >> "$file"
				echo '<br>KEYWORD '$j': '${!j} >> "$file"		# -e enables the interpretation of '\' characters
				sed -i -e ':a' -e 'N' -e '$!ba' -e 's/\n/<br>/gI' ".$file.text.txt" #Replacing new line character with <br>
				sed -i -e "s/${!j}/<mark>${!j}<\\/mark>/gI" ".$file.text.txt" #Highlighting the keyword wherever it is appearing
				cat ".$file.text.txt" >> "$file"
				echo "</pre>" >> "$file"
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
	done
	IFS="$OIFS"
fi
rm ".$file.text.txt" ".$file.tmp.txt"
echo "</body>" >> "$file"
echo "</html>" >> "$file"
echo #Empty echo for new line