Created by Aabhas Vineet Malik (email: aabhaas.iiser@gmail.com) and Ankur Shringi (email: ankurshringi@iisc.ac.in)

Last Modification date : 2020-Apr-23

-----------------------------------------------------------------------------
# Motivation

A literature review requires going through a lot of research articles. While going through these research articles (which are mostly stored as pdfs locally), we sometimes just want to look for the occurrences or usage of a specific text/ keywords (such as species name or method or a technical term). One way to solve this problem is to skim through all the articles, looking for such keywords (which is long and tedious), and other is to use a reference manager such as Mendeley or Zotero (and many others). Each solution comes with it own pros and cons. There could be other ways of solving this problem but we are not aware of any such neat, completely **free and open source** solution (please contact us if you have such a solution in mind).

A semi ideal way to solve this problem is to write a script, which goes through all the stored pdfs, reads their text automatically, searches these keywords and provides a summary report as an output. This is what is being attempted in the scripts available in this repository.

We are providing two shell scripts 

  - **sorting_script_html.sh** (For html summary)
  - **sorting_script_txt.sh** (For organizing pdfs in the keyword folders, hard-linking the pdfs and summary in text.txt file)

There are two additional scripts which help us sort the pdf names and metadata. 

  - **edit_pdf_metadata.sh** (Embeds given information in the pdf metadata)
  - **script_rename_hardlinks_by_master_list.bat** (Automatically renaming all the pdfs which are hard-linked together)

A detailed description and usage of each of these script is provided below.

# Scripts

## **sorting_script_html.sh**

This is a shell script which can be used with a bash terminal to find pdf files in a given folder which contain one or more given keywords in their display-able contents or their metadata.

The script extracts text from all the pdfs located in the chosen folder, searches the keywords and its context (surrounding sentences around the keyword) and creates a html summary of all the results. This html file lists all the pdfs (hyper-linked) in which the keywords are found and highlights the keyword in the surrounding text to clarify the context in which the keywords have been used.

You need to use it to get a feel for it. Please make sure you have the set-up ready before launching it (See section 3: **Prerequisites** (especially the windows users)).  

**Usage**

| Search for a keyword                                         |
| ------------------------------------------------------------ |
| `./sorting_script_html.sh study`                             |
| **Search multiple keywords** (with OR operator) <br />Ex.: "study" **or** "crop yield" <br />(This will look for pdfs which contains either "study" or "crop yield") |
| `./sorting_script_html.sh study "crop yield"`                |
| **Search multiple keywords** (with AND operator)<br /> Ex.: "study" **and** "crop yield" <br />(This will look for pdf which contains both "study" as well as "crop yield" simultaneously) |
| `./sorting_script_html.sh -o "&" study "crop yield"`         |
| **Search keyword in first 3 pages of each pdf**              |
| `./sorting_script_html.sh -p 3 study`                        |
| **Search keyword in first 1000 words of each pdf**           |
| `./sorting_script_html.sh -n 1000 study`                     |
| **Help function in command line**                            |
| `./sorting_script_html.sh -?`                                |

**Note:-**

- **sorting_script_html.sh** uses a JavaScript file **toc.js** for creating a table of contents automatically with the names of the pdf files in which the keywords are found. So keep this file in the same folder as this script.
- This scripts outputs the results in **Summary** folder in the parent directory of the current directory. 

**Known issues**

- Name and location of the summary folder is currently fixed to 'Summary' and the parent folder, respectively.

## **sorting_script_txt.sh**

Works similar to **sorting_script_html.sh** except if a keyword is entered, a folder with the same name as the keyword will be created and pdf hardlinks of the matches will be dumped there. On the other hand, if more than one keyword is given, all pdf files which qualify are named at the terminal output.  

## **edit_pdf_metadata.sh**

This script allows the user to edit the pdf metadata (for example, author names, keywords which are otherwise not in the displayed text of the pdf file, etc.) of any pdf file (even those which do not have a searchable display text).

## **script_rename_hardlinks_by_master_list.bat**

Once you start using shell scripts especially **sorting_script_txt.sh**, you soon end up having multiple pdf hard-links of the same file located in different folders. Sometimes you have duplicated pdfs having different names, or sometimes you happen to rename a pdf without realizing that multiple hard-links exist. The dis-advantage (or advantage) of renaming a hard-link is that it doesn't rename all the other hard-links associated with it. If you want all the hard-links of a file to have the same file name then you need to manually locate and rename such hard-links. Here is a script which does this automatically. It renames all the associated hard-links (doesn't matter where they are located) of the files to match their names in the folder where this script is located and launched from. 

**Known issues:**

- Currently works on Windows only

-----------------------------------------------------------------------------
# Prerequisites

## Linux (tested on Ubuntu 16.04)
  - There are no prerequisites for the **sorting_script_txt.sh** on Linux systems.
  - However for **sorting_script_html.sh** you need to install pdftotext library (See section for **Windows 10**)
  - To use the edit_metadata.sh script you will need to install pdftk, which can be done in Ubuntu by issuing the following command at the terminal 'sudo snap install pdftk'.

## Windows10 
  - Install Windows Subsystem for Linux (WSL) (https://docs.microsoft.com/en-us/windows/wsl/install-win10)
  - Open Linux terminal and type
    - $ sudo apt get update
    - $ sudo apt-get install build-essential libpoppler-cpp-dev pkg-config python3-dev 
    - $ sudo apt-get install python3-pip
    - $ sudo pip3 install pdftotext
    - $ sudo apt-get install poppler-utils

-----------------------------------------------------------------------------

# Getting started
  - Open linux terminal 
  - cd to the desired folder (might need to use cd /mnt/c/users/... for windows)
  - Copy the script to the folder which contains your pdf files.
  - Change the permission of the script so that it is executable (chmod -755 name-of-the-script-file)
  - Put following command to get further instructions on how to use it
    - $ ./name-of-the-script-file

On a Linux system you may also copy these scripts to /usr/local/bin/ and rename them if you like. This will make them accessible as commands at the terminal prompt (the name of the script in /usr/local/bin/ will serve as the command name), and you will not have to copy the script every time to the folder you want to use them in.

* **script_rename_hardlinks_by_master_list.bat** 
  * Its an self executable file, can only be used in Windows currently.
  * Place this file or its hardlink in the reference directory (The folder in which all the files with reference names are located). Click on the file or right click or open it to execute.

# Additional resources for Windows10 user

* Updating WSL or its packages

```
sudo apt-get update && sudo apt-get dist-upgrade
```

* Adding bash icon on right click menu

https://www.windowscentral.com/how-launch-bash-shell-right-click-context-menu-windows-10

- Creating hard-link or symbolic links without command line

Link to Shell Extension is fantastic utility to create all types of links or junctions. Please see the information at the link below.

https://schinagl.priv.at/nt/hardlinkshellext/linkshellextension.html

# Feedback

* Please feel free to raise an issue on github if you may find a bug or want to suggest a feature. 

* If you come across any free opensource tool which surpasses what is being achieved here then please let us know.

* If you want to improve on it, feel free to fork it. Or, if you want to join as a contributor then email the lead author Aabhaas (aabhaas.iiser@gmail.com).

  
