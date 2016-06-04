###dropkg

UPDATE: make/unmake .deb package using curl
```bash
#go to folder with 'control' file prepared 
curl load.sh/dropkg|perl
```

![dropkg-curl](https://raw.githubusercontent.com/z448/dropkg/master/dropkg-curl.gif)


Makes debian binary package without need of dpkg. 

*Not a replacement of dpkg as title might suggest, it's meant to be used for packing quick custom builds which could be then installed by dpkg or just unpacked into any directory.*

It uses perl ar-chiver which is dowloaded on first run. Wont mess your PATH or current ar-chiver as it's placed into tmp directory and doesn't have execute permissions. In case you want to keep libd just copy them from /tmp/dropkg ..*

**Basic Usage**

```shell
dropkg
```

To create or reverse .deb package, `dropkg` doesn't need any parameter. If there is `control` file in current directory it makes `.deb` package, if there is `.deb` package it unpack it into original tree. Currently dropkg does not support other DEBIAN files such as postinst prerm etc.

![dropkg](https://raw.githubusercontent.com/z448/dropkg/master/dropkg.gif)

It's made like this so it can be placed on server and piped to perl with `curl` or `wget`... You can try it by copying URL of `dpkg-drop.pl` after clicking `raw` button. (```curl https://raw.githubusercontent.com/z448/dropkg/master/dpkg-drop.pl | perl```)


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


*fixed*

~~*during install you might get some warnings, but package will be installed, you can ignore it for now,will be fixed..*~~
