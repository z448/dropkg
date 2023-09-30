# NAME

dropkg - creates debian binary packages

# VERSION

This document describes dropkg version 2.0.5

# GIF

![dropkg](https://raw.githubusercontent.com/z448/dropkg/master/dropkg.gif)

# INSTALLATION

iOS

```bash
git clone http://github.com/z448/dropkg
cd dropkg/deb
sudo dpkg -i dropkg_2.0.5_all.deb
```

Linux/Unix

```bash
git clone http://github.com/z448/dropkg
perl Makefile.PL
make
make install
```
               
# SYNOPSIS

- Without any option dropkg creates debian bianry package with contents of current directory if there is control file in it. If there is debian package in current directory dropkg will unkack it into current directory.
- `-v` show version
- `-c` set compression for data, recognized compression options: gzip, bzip2, lzma, xz, zstd
- `-t` show control file template  
- `-m` show debian policy manual 

# DESCRIPTION

Creates debian bianry package with contents of current directory if there is a control file in it. If there is debian package in it dropkg will extract its content into current directory.

# EXAMPLES

- To create .deb package:

    You want to create .deb package that will install your program 'myprg' into '/usr/bin' directory. Create empty directory of any name then create 'usr/bin' path in that directory and move your program into that path.

    `mkdir MyTmp`

    `mkdir -p MyTmp/usr/bin`

    `mv myprg MyTmp/usr/bin`

    Place 'control' file into 'MyTmp' directory. `dropkg -t` can print template of control file.

    `mv control MyTmp`

    `cd MyTmp`

    Run dropkg without any options to create .deb package.

    `dropkg`

    Name of .deb file is taked from control file, Package\_Version\_Architecture.deb. To have different .deb filename pass it as 1st parameter `dropkg filename.deb`.
    By default gzip compression is used for data unless ~/.dropkg config contains different compression option. Compression can be also set by `-c` switch.  

- To unpack .deb package:

    Go into directory that contains .deb package and run `dropkg` without any option. If there is more than one .deb file in current directory pass filename as first parameter `dropkg filename.deb`.

# DEVELOPMENT

dropkg is hosted on [github](https://github.com/z448/dropkg). You can track and contribute to its development there.

# AUTHOR

Zdeněk Bohuněk, `<zdenek@cpan.org>`

# COPYRIGHT

Copyright © 2016-2023, Zdeněk Bohuněk `<zdenek@cpan.org>`. All rights reserved.

This code is available under the Artistic License 2.0.
