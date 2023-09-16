# NAME

dropkg - creates debian binary packages

# VERSION

This document describes dropkg version 1.9.5

# GIF

![dropkg](https://raw.githubusercontent.com/z448/dropkg/master/dropkg.gif)

# INSTALLATION

iOS

```bash
git clone http://github.com/z448/dropkg
cd dropkg/deb
sudo dpkg -i dropkg_1.9.5_iphoneos-arm.deb
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
- `-c` set compression for data, supported compression strings: gzip(default), bzip2, lzma, xz
- `-v` show version
- `-t` show control file template  
- `-m` show debian policy manual 

# DESCRIPTION

Creates debian bianry package with contents of current directory if there is control file in it. If there is debian package in current directory dropkg will unkack it into current directory.

# EXAMPLES

- To create .deb package:

    You want to create .deb package that will install your program 'myprg' into '/usr/bin' directory. Create empty directory of any name (think of it as root '/' directory) then create 'usr/bin' path in that directory and move your program into that path.

    `mkdir MyTmp`

    `mkdir -p MyTmp/usr/bin`

    `mv myprg MyTmp/usr/bin`

    `cd MyTmp`

    Place 'control' file into 'MyTmp' directory. `dropkg -t` can print you template of control file.

    To create package run dropkg without any option.

    `dropkg`

    Name of .deb file is taked from control file, Name + Version + Architecture + .deb.
    To have different .deb filename pass it as 1st parameter `dropkg myprg.deb`. 

- To unpack .deb package:

    Go into directory that contains .deb package and run `dropkg` without any option. If there is more than one .deb file in current directory pass file name as first argument `dropkg file.deb`.

# DEVELOPMENT

dropkg is hosted on [github](https://github.com/z448/dropkg). You can track and contribute to its development there.

# AUTHOR

Zdeněk Bohuněk, `<zdenek@cpan.org>`

# COPYRIGHT

Copyright © 2016-2023, Zdeněk Bohuněk `<zdenek@cpan.org>`. All rights reserved.

This code is available under the Artistic License 2.0.
