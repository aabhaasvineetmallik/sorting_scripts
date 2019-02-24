#!/bin/bash
# Created by Aabhas Vineet Malik (email: aabhaas.iiser@gmail.com)
# Last Modification date : 2018-Apr-11

# Prerequisits
#	pdftk

# Get instructions on how to use by using this command on the terminal
# ./edit_pdf_metadata.sh

DUMMY_FILE="__UPDATE__"

if [ $# -eq 0 ]
then
	echo "***********MODE 1**********************"
	echo "enter the address of the pdf file to see its meta-data"
	echo ""
	echo "***********MODE 2**********************"
	echo "follow MODE 1 and after a space enter the InfoKey within \" \", that you want to check"
	echo ""
	echo "***********MODE 3**********************"
	echo "follow MODE 2 and after a space enter the values within \" \""
	echo "if the particluar InfoKey is already there values will be concatenated else the InfoKey will be initiated"
	echo "***********MODE 4**********************"
	echo "follow MODE 3 and after another space enter 'change' to change the existing InfoValue"
elif [ $# -eq 1 ]
then
	echo "$(pdfinfo $1)"	#"$(pdftk $1 dump_data)"
elif [ $# -eq 2 ]
then
	COMMAND="pdftk $1 dump_data | awk '{if(\$0 == \"InfoKey: $2\"){print \$0; getline; print \$0}}'"
	eval "$COMMAND"
elif [ $# -eq 3 ]
then
	if pdftk $1 dump_data 2>/dev/null | grep $2
	then
		echo "for $1 InfoKey: $2 exists"
		echo "for $1 starting concatenation to InfoKey: $2"
		COMMAND="pdftk $1 dump_data | awk '{if(\$0 == \"InfoKey: $2\"){getline; print \$0}}'"
		OLD_KEYS="$(eval $COMMAND)"
		NEW_KEYS="$OLD_KEYS, $3"
	else
		echo "for $1 InfoKey: $2 doesn't exist"
		echo "for $1 creating InfoKey: $2"
		NEW_KEYS="$3"
	fi
	if ls $DUMMY_FILE.* 2>/dev/null
	then
		echo "if possible please rename the $DUMMY_FILE file and rerun the script again"
	else
		echo "InfoKey: $2" > $DUMMY_FILE.txt
		echo "InfoValue: $NEW_KEYS" >> $DUMMY_FILE.txt
		eval "cp $1 $DUMMY_FILE.pdf"
		eval "pdftk $DUMMY_FILE.pdf update_info $DUMMY_FILE.txt output $1"
		eval "rm $DUMMY_FILE.*"
	fi

else
	echo "for $1 changing InfoKey: $2"
	NEW_KEYS="$3"

	if [ $(ls $DUMMY_FILE.* 2>/dev/null) ]
	then
		echo "if possible please rename the $DUMMY_FILE file and rerun the script again"
	else
		echo "InfoKey: $2" > $DUMMY_FILE.txt
		echo "InfoValue: $NEW_KEYS" >> $DUMMY_FILE.txt
		eval "cp $1 $DUMMY_FILE.pdf"
		eval "pdftk $DUMMY_FILE.pdf update_info $DUMMY_FILE.txt output $1"
		eval "rm $DUMMY_FILE.*"
	fi
fi
