Created by Aabhas Vineet Malik (email: aabhaas.iiser@gmail.com)

Modified by Ankur Shringi (email: ankurshringi@iisc.ac.in)

Last Modification date : 2019-Feb-03

-----------------------------------------------------------------------------
#Description

We are providing three shell script files in this repository:

The sorting_script_html.sh (sorting_script_txt.sh) is a shell script which can be used with a bash terminal to find pdf files in a given folder which contain the supplied keywords either in the displayed texts or in their metadata. If only one keyword is entered, a folder with the same name as the keyword is created and hardlinks of the matches will be dumbed there. On the other hand, if more than one keyword is given, all pdf files which qualify are named at the terminal output. This script also creates text.html (text.txt) file to display the context in which the supplied keywords appeared in the pdf files found during the search.

We are also providing a script, edit_pdf_metadata.sh, which allows the user to edit the metadata (for example, author names, keywords which are otherwise not in the displayed text of the pdf file, etc.) of any pdf file (even those which do not have a searchable display text).

-----------------------------------------------------------------------------
#Prerequisits

Prerequisits on Linux

There are no prerequisits for the sorting_script_html.sh (sorting_script_txt.sh) on Linux systems (tested on Ubuntu 16.04).

To use the edit_metadata.sh script you will need to install pdftk, which can be done in Ubuntu by issuing the following command at the terminal 'sudo apt-get install pdftk'.

Prerequisits on Windows10 (compatibility of this code with Windows10 has not been checked)

 Install Windows Subsystem for Linux (WSL) (https://docs.microsoft.com/en-us/windows/wsl/install-win10)

Open Linux terminal and type

 sudo apt get update

 sudo apt-get install build-essential libpoppler-cpp-dev pkg-config python-dev 

 sudo apt-get install python-pip

 pip install pdftotext

 sudo apt-get install poppler-utils

-----------------------------------------------------------------------------

How to use

 Open linux terminal

 cd to the desired folder (might need to use cd /mnt/c/users/... for windows)

 Copy the script to the folder which contains your pdf files.

 Change the permission of the script so that it is executable (chmod -755 name-of-the-script-file)

 Put following command to get further instructions on how to use it

 ./name-of-the-script-file

On a Linux system you may also copy these scripts to /usr/local/bin/ and rename them if you like. This will make them accessible as commands at the terminal prompt (the name of the script in /usr/local/bin/ will serve as the command name), and you will not have to copy the script everytime to the folder you want to use them in.
