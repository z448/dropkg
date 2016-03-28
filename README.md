###dropkg




Makes debian binary package without need of dpkg. 

*Not a replacement of dpkg as title might suggest, it's meant to be used for packing quick custom builds which could be then installed by dpkg or just unpacked into any directory. It uses perl ar-chiver which is dowloaded on first run. Wont mess your PATH or current ar-chiver as it's placed into tmp directory and doesn't have execute permissions*

![dropkg](https://raw.githubusercontent.com/z448/dropkg/master/dropkg.gif)
UPDATED: downloads getopts.pl module on first run along with archiver

~~getopt.pl error workaround*
:-/ ar is using Perl4::CoreLib module - try `cpan Perl4::CoreLibs` as temp fix~~

NOTE: In case you are packaging Perl5 module, see `dpp` instead..

**Install**

No installation needed, clone repo and change permissons `chmod +x dropkg`, or just copy/paste script

**Usage:**

First create `directory`, place all files + `control` file in it as you would do with `dpkg-deb`. Then run `dropkg` inside `directory`

```bash
dropkg <package-name>
```

*or*

if run w no parameter it takes `Package` value from `control` file and uses it as `package-name`

```bash
dropkg
```

install package w `dpkg -i` as usual

```bash
dpkg -i <package-name>
```


~~*during install you might get some warnings, but package will be installed, you can ignore it for now,will be fixed..*~~
