# NAME

dropkg - creates debian binary (.deb) packages

# INSTALLATION

If you are on iOS:

you can use dropkg.deb in deb/ios folder and install as root with `dpkg -i dropkg.deb` or add source http://load.sh/cydia/ into Cydia and search for 'dropkg'

If you are on Linux/OSX:

\# Install

`git clone http://github.com/z448/dropkg`

`cd dropkg`

\# setup

`source ./env.sh`

# SYNOPSIS

Creates debian .deb packages, uses perl implementation of 'ar' archiver and Filesys::Tree module. Both are downloaded and set up on first run, you need to have 'curl' installed. Without any option, dropkg creates .deb package if there is control file in current directory. Name of .deb file is taked from control file, Name + Architecture + Version + .deb. If there is .deb file in current directory it will unpack contents of package into original tree. Because these two functions (pack/unpack .deb) doesnt require any options, it's possible to place it on server and using curl (or wget) pipe into perl interpreter in terminal. 

Dropkg supports mandatory control file and two optional debian files: prerm and postinst

Example: `curl website.com/dropkg | perl`

\- this will pack everything in current directory into .deb file if there is control file in current directory
\- or if there is .deb file in current directory it'll unpack it into original tree

# EXAMPLES

Create .deb package:

\- place your files into directory along with prepared control file then `cd directory`

`dropkg`

\- name of .deb file is taked from control file, Name + Architecture + Version + .deb

\- to have different .deb filename pass it as 1st parameter `dropkg myapp.deb` creates myapp.deb package. 

Unpack .deb package

\- go into directory that contains .deb package

`dropkg`

Print control template

`dropkg -t`

Open Debian Policy Manual in browser 

`dropkg -m`
