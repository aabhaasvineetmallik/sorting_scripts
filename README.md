Created by Aabhas Vineet Malik (email: aabhaas.iiser@gmail.com) and Ankur Shringi (email: ankurshringi@iisc.ac.in)

Last Modification date : 2019-Feb-25

-----------------------------------------------------------------------------
# Description

We are providing three shell script files and one bat script in this repository:
  - sorting_script_html.sh
  - sorting_script_txt.sh
  - edit_pdf_metadata.sh
  - script_rename_hardlinks_by_master_list.bat (**only for windows**)

The **sorting_script_html.sh** (**sorting_script_txt.sh**) is a shell script which can be used with a bash terminal to find pdf files in a given folder which contain the supplied keywords either in the displayed texts or in their metadata. If only one keyword is entered, a folder with the same name as the keyword is created and hardlinks of the matches will be dumped there. On the other hand, if more than one keyword is given, all pdf files which qualify are named at the terminal output. This script also creates <Keyword>.html (text.txt) file to display the context in which the supplied keywords appeared in the pdf files found during the search. **sorting_script_html.sh** use a JavaScript file **toc.js** for automatically creating table to contents automatically by the names of pdf files in which the keyword in found. 



We are also providing a script, **edit_pdf_metadata.sh**, which allows the user to edit the metadata (for example, author names, keywords which are otherwise not in the displayed text of the pdf file, etc.) of any pdf file (even those which do not have a searchable display text).

Once you start using such scripts, you end up having multiple hardlinks of a same files located in different folders. Sometimes we have duplicated pdfs having different names, or sometimes we happen to rename a pdf without realizing that multiple hardlinks exists. The dis-advantage (or advantage) of renaming a hardlink is that it doesnt rename all other hardlinks associated to its files. If we want all the hardlinks of a file to have same file name then you need to manually locate and rename such hard-links. **script_rename_hardlinks_by_master_list.bat** is a script which does this automatically. It renames all the associated hardlinks (doesn't matter where they are located) of the files, same as the names of the files located in which the script is located. 

-----------------------------------------------------------------------------
# Prerequisites

## Prerequisites on Linux (tested on Ubuntu 16.04)
  - There are no prerequisites for the sorting_script_html.sh (sorting_script_txt.sh) on Linux systems.
  - To use the edit_metadata.sh script you will need to install pdftk, which can be done in Ubuntu by issuing the following command at the terminal 'sudo apt-get install pdftk'.

## Prerequisites on Windows10 (compatibility of this code with Windows10 has not been checked)
  - Install Windows Subsystem for Linux (WSL) (https://docs.microsoft.com/en-us/windows/wsl/install-win10)
  - Open Linux terminal and type
    - $ sudo apt get update
    - $ sudo apt-get install build-essential libpoppler-cpp-dev pkg-config python-dev 
    - $ sudo apt-get install python-pip
    - $ pip install pdftotext
    - $ sudo apt-get install poppler-utils

-----------------------------------------------------------------------------

# How to use
  - Open linux terminal
  - cd to the desired folder (might need to use cd /mnt/c/users/... for windows)
  - Copy the script to the folder which contains your pdf files.
  - Change the permission of the script so that it is executable (chmod -755 name-of-the-script-file)
  - Put following command to get further instructions on how to use it
    - $ ./name-of-the-script-file

On a Linux system you may also copy these scripts to /usr/local/bin/ and rename them if you like. This will make them accessible as commands at the terminal prompt (the name of the script in /usr/local/bin/ will serve as the command name), and you will not have to copy the script every time to the folder you want to use them in.

* **script_rename_hardlinks_by_master_list.bat** 
  * Its an self executable file, can only be used in Windows currently.
  * Place this file or its hardlink in the reference directory (The folder in which all the file with reference names are located). Click on the file or right click or open it to execute.
