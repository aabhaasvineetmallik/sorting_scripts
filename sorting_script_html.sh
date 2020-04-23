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

Operator="|"
N_max="1000"
page_f=2
# Section with optional arguments------------------------------------------------------------------
helpFunction()
{
   echo ""
   echo "  Usage: $0 -o 'Operator' -p 'page_f' -n 'N_max' keyword_1 keyword_2"
   echo
   echo -e "\t-o Operator: string ('&' or '|') ; default is '|' "
   echo -e "\t           : Operator to be applied if multiple keywords are entered!"
   echo
   echo -e "\t-p page_f  : number ( >=01 )     ; default is 2"
   echo -e "\t           : Page number till where pdf needs to be searched"
   echo
   echo -e "\t-n N_max   : number ( >=50)      ; default is 1000"
   echo -e "\t           : Maximum number of words in which search needs to be made!"
   echo
   echo -e 
   echo -e "Valid Examples- "
   echo -e "\t $0 facebook "
   echo -e "\t $0 facebook experience"
   echo -e "\t $0 -p 2 -n 100 facebook experience"
   echo -e "\t $0 -p 2 -n 1000 -o '&' facebook experience"
   echo
   echo -e "Invalid Examples"
   echo -e "\t $0 facebook experience -p 2 -n 100 "
   
   exit 1 # Exit script after printing help
}
OPTIND=1
while getopts ":o:p:n:" opt
do
   case "$opt" in
      n ) N_max="$OPTARG" ;;	  
      o ) Operator="$OPTARG" ;;
      p ) page_f="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
# if [ -z "$N_max" ] || [ -z "$page_f" ]
# then
   # echo "Some or all of the parameters are empty";
   # helpFunction
# fi
echo
echo "                Operator for search strings : $Operator"
echo "             Number of pages being searched : $page_f"
echo "In these pages, no. of words being searched : $N_max"
# Begin script in case all parameters are correct
shift "$((OPTIND-1))"

# Creating html file in a folder in parent directory------------------------------------------------------------------
pd="$(dirname "${PWD}")" # Parent Directory
#echo "$pd"
folder_html="Summary" 
path_folder_html="$pd/$folder_html"
#echo "$path_folder_html"
mkdir -p "$path_folder_html"
# Sorting multiple arguments.
if [ "$Operator" == "&" ]
then
	join="_x_"
else
	join="_+_"
fi
name=$(for var in "$@"; do
    echo "$var"
done | sort | paste -s -d '#' | sed "s/\#/$join/g")
file="$path_folder_html/$name.html"
rm "$file" 2> /dev/null
#echo "$file"
#echo "$file"
N_max="$N_max" 	# Number of lines to be read from the starting of the file
page_i=1
page_f=2
folder="${PWD##*/}"

echo "<!DOCTYPE html>" >> "$file"
echo "<html>" >> "$file"
echo "<head>" >> "$file"
echo "<title>"$name"</title>" >> "$file"
echo "<meta name='viewport' content='width=device-width, initial-scale=1'/>" >> "$file"
echo '<script type="text/javascript">' >> "$file"
cat "toc.js" >> "$file"
echo '</script>' >> "$file"
echo "</head>" >> "$file"
echo '<body onload="generateTOC(document.getElementById(`toc`));">' >> "$file"
echo '<div id="toc"></div>' >>"$file"
if [ $# -eq 0 ]
then
	echo
	echo "Error: Missing a keyword to be searched!!"
	echo
	echo "For more details type following:"
	echo -e "$0 -?"	
	echo
	echo "if more than one keyword is given, all matches will be displayed"
	echo 'If you want to search for a phrase put it in quotes Ex. "Quantum Computing"'
	echo "a file will always be created giving the context in which the keywords appear in the pdf files"
elif [ $# -eq 1 ]
then
	echo
	echo "    The number of inputs search keywords is : 1"
	echo
	echo "   Results are being segregated in the file : '"$file"'"
	echo
	echo "Use '-n' option to change the number of words from which to search "
	echo
	echo "For more details type following:"
	echo -e "$0 -?"
	
else
	echo
	echo "    The number of inputs search keywords is : "$# ""
	echo
	echo "   Results are being segregated in the file : '"$file"'"
	echo "Use '-n' option to change the number of words from which to search "
	echo "Use '-o' option to give operator '&' or '|' to use as boolean operator."
	echo
	echo "For more details type following:"
	echo -e "$0 -?"	
	echo "  (Results from first keyword will appear first, followed by the rest. Scroll down to see other keywords.)"
	echo
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
		pdftotext -f $page_i -l $page_f $i -| less -f | head -$N_max > ".temp.tmp.txt"
		
		if [ "$Operator" == "&" ]
		then
			stop=0			
			for ((k=1; k<$#+1; k=k+1))
			do
				COMMAND=$(grep -in ${!k} -C 5 ".temp.tmp.txt")
				if [ -n "$COMMAND" ]
				then
					stop=$(($stop+1))
						continue
				else
					break
				fi
				echo "&:$stop"
			done
		else
			stop=$(($#))
		fi	
		if [ "$stop" -eq $# ]
		then	
			for ((j=1; j<$#+1; j=j+1))
			do			
				COMMAND_ONE=$(grep -in ${!j} -C 5 ".temp.tmp.txt" | tee ".temp.text.txt")		#${!#} gives access to the last argument supplied to the script
				COMMAND_TWO=$(pdfinfo $i 2>/dev/null | grep -i ${!j})
				if [ -n "$COMMAND_ONE" ] || [ -n "$COMMAND_TWO" ]	#'-n' checks that the string is not empty. for more options see 'man test'
				then
					FLAG=1
					echo '<h2 id = "'$i'">' >> "$file"
					echo -e '<a href = "../'$folder'/'$i '" target = "_blank">' $i'</a></h2>' >> "$file"
					echo '<a href="#toc">Go back to the table of contents!</a>' >> "$file"
					echo '<pre>' >> "$file"
					echo '<br>KEYWORD '$j': '${!j} >> "$file"		# -e enables the interpretation of '\' characters
					sed -i -e ':a' -e 'N' -e '$!ba' -e 's/\n/<br>/gI' ".temp.text.txt" #Replacing new line character with <br>
					sed -i -e "s/${!j}/<mark>${!j}<\\/mark>/gI" ".temp.text.txt" #Highlighting the keyword wherever it is appearing
					cat ".temp.text.txt" >> "$file"
					echo "</pre>" >> "$file"
					continue
				else
					FLAG=0
					j=$(($#+1))
				fi
			done
		fi
		if [ $FLAG -eq 0 ]
		then
			continue
		fi
	done
	IFS="$OIFS"
fi
rm ".temp.text.txt" ".temp.tmp.txt"
echo "</body>" >> "$file"
echo "</html>" >> "$file"
echo #Empty echo for new line
echo
