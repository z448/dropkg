# NAME

dropkg - creates debian binary packages

# VERSION

This document describes dropkg version 2.0.17

# GIF

![dropkg](https://raw.githubusercontent.com/z448/dropkg/master/dropkg.gif)

# INSTALLATION

```bash
git clone http://github.com/z448/dropkg
cd dropkg/deb
dpkg -i dropkg_2.0.17_all.deb
```

### OR

```bash
cpan Filesys::Tree Archive::Ar
git clone http://github.com/z448/dropkg
cd dropkg
perl Makefile.PL
make
make install
```
                
# SYNOPSIS

- If there is a control file in current directory dropkg will create debian binary package with contents of current directory. If there is a debian package in current directory dropkg will extract its contents into current directory.
    - `-v` show version
    - `-c` set compression for data archive: gzip, bzip2, lzma, xz, zstd
    - `-s` generate md5sums file and include it in package
    - `-t` show control file template  
    - `-m` show debian policy manual 
    - `-h` show help

# EXAMPLES

##### Creating .deb package:
    
- You have program 'myprg' that is using config file 'myprg.conf'. To create .deb package that will install program into '/usr/bin' directory and place config file into '/etc' directory create 'usr/bin' and 'etc' paths in current directory and move there program and config file.
```sh
$ pwd
~/myTmp

$ ls
myprg   myprg.conf

$ mkdir -p usr/bin
$ mv myprg usr/bin/
$ mkdir etc
$ mv myprg.conf etc/
```

- Create 'control' file. To see control file template use `-t` option.
```bash
$ dropkg -t | grep mandatory > control

$ cat control
Maintainer: (mandatory)
Package: (mandatory)
Version: (mandatory)
Architecture: (mandatory)
Depends: (mandatory if package has dependencies)
Description: (mandatory)
```

- Fill in mandatory parts of control file with editor and use dropkg without any option to create .deb package.
```bash
$ ls
control  etc  usr

$ cat control
Package: myprg
Version: 1.0
Architecture: iphoneos-arm
Depends: perl
Maintainer: zdenek <zdenek@cpan.org>
Description: my test program

$ tree
.
├── control
├── etc
│   └── myprg.conf
└── usr
    └── bin
        └── myprg

$ dropkg
myprg_1.0_iphoneos-arm.deb
```

- dropkg is using control file to create name for .deb package, Package\_Version\_Architecture.deb. To have different .deb filename pass it as first parameter `dropkg filename.deb`.
- by default gzip compression is used for data unless '~/.dropkg' config contains different compression option. Compression can be also set by `-c` switch.  


##### Extracting .deb package:
- Go into directory that contains .deb package and run `dropkg` without any option. If there is more than one .deb file in current directory pass filename as first parameter `dropkg filename.deb`.
```bash
$ ls
myprg_1.0_iphoneos-arm.deb

$ dropkg
.
├── control
├── etc
│   └── myprg.conf
└── usr
    └── bin
        └── myprg

$ ls
control  etc  usr
```

# DEVELOPMENT

dropkg is hosted on [github](https://github.com/z448/dropkg). You can track and contribute to its development there.

# AUTHOR

Zdeněk Bohuněk, `<zdenek@cpan.org>`

# COPYRIGHT

Copyright © 2016-2023, Zdeněk Bohuněk `<zdenek@cpan.org>`. All rights reserved.

This code is available under the Artistic License 2.0.
