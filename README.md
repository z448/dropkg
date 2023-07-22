# NAME

dropkg - creates debian binary packages

# GIF

![dropkg](https://raw.githubusercontent.com/z448/dropkg/master/dropkg.gif)

# INSTALLATION

```bash
git clone http://github.com/z448/dropkg
cd dropkg/deb
sudo dpkg -i ./dropkg_1.9.3-4_all.deb
```

# SYNOPSIS

Creates debian bianry package with contents of current directory if there is control file in it. If there is debian package in current directory dropkg will unkack it into current directory.
dropkg supports mandatory control file and two optional debian files: prerm and postinst

# EXAMPLES

To create .deb package:

You want to create .deb package that will install your program 'myprg' into '/usr/bin' directory. Create empty directory of any name (think of it as root '/' directory) then create 'usr/bin' path in that directory and move your program into that path.

```bash
mkdir MyTmp
mkdir -p MyTmp/usr/bin
mv myprg MyTmp/usr/bin
cd MyTmp
```

Place 'control' file into 'MyTmp' directory. "dropkg -t" can print you template of control file.

```bash
dropkg
```

Name of .deb file is taked from control file, Name + Version + Architecture + .deb.
To have different .deb filename pass it as 1st parameter "dropkg myprg.deb". 


To unpack .deb package:

Go into directory that contains .deb package and run "dropkg" without any option.
