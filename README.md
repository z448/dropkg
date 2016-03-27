###dropkg

**makes debian binary package without need of dpkg**

**Install**

*no installation needed, clone repo and change permissons `chmod +x dropkg`, or just copy/paste script*

**Usage:**

*first create <directory>, place all files + `control` file in it as you would do with `dpkg-deb`. Then run `dropkg` inside <directory>*

```bash
dropkg <package-name>
```

*or if used w no parameter it takes `Package` field from `control` file*

```bash
dropkg
```

*install package w `dpkg -i` as usual*

```bash
dpkg -i <package-name>
```
