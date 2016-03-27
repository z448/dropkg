###dropkg

Makes debian binary package without need of dpkg

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

*install package w `dpkg -i` as usual*

```bash
dpkg -i <package-name>
```
