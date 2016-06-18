#dropkg

UPDATE: 

Sat Jun 18 06:44:09 CEST 2016
**-m** *option open Debian Policy Manual in browser
**-t** *option prints control file template*
**-e** *option print control file example with cydia specific notes*

make/unmake .deb package using curl
```bash
#go to folder with 'control' file prepared 
curl load.sh/dropkg|perl
```

![dropkg-curl](https://raw.githubusercontent.com/z448/dropkg/master/dropkg-curl.gif)


Makes debian binary package without need of dpkg. 

*Not a replacement of dpkg as title might suggest, it's meant to be used for packing quick custom builds which could be then installed by dpkg or just unpacked into any directory.*

###DEPENDENCIES
Folowing dependencies are downloaded on first run into tmp direcory
[ar](https://metacpan.org/pod/PerlPowerTools), [Filesys::Tree](https://metacpan.org/pod/Filesys::Tree), [getopts.pl](https://metacpan.org/pod/Perl4::CoreLibs)

It uses perl ar-chiver which is dowloaded on first run. In case you want to keep libraries just copy them from /tmp/dropkg ..*

**Basic Usage**

```shell
dropkg
```

To create or reverse .deb package, `dropkg` doesn't need any parameter. If there is `control` file in current directory it makes `.deb` package, if there is `.deb` package it unpack it into original tree. Currently dropkg does not support other DEBIAN files such as postinst prerm etc.

![dropkg](https://raw.githubusercontent.com/z448/dropkg/master/dropkg.gif)

NOTE: In case you are packaging Perl5 module, see `dpp` instead..

**Install**

No installation needed, clone repo and change permissons `chmod +x dropkg`, or just copy/paste script

**Usage:**

First create `directory`, place all files + `control` file in it as you would do with `dpkg-deb`. Then run `dropkg` inside `directory`

```bash
dropkg <package-name>
```

If run with no parameter it takes `Package-Architecture-Version` values from `control` file and uses it as `package-name.deb`

```bash
dropkg
```

install package w `dpkg -i` as usual

```bash
dpkg -i <package-name>
```


*fixed*

~~*during install you might get some warnings, but package will be installed, you can ignore it for now,will be fixed..*~~
