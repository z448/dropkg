TODO

**fix error on load.sh debian**

```
~/dpp/stash/deb/tmp pwd
/home/mobile/dpp/stash/deb/tmp
~/dpp/stash/deb/tmp ls
libhttp-tinyish-p5220.deb
~/dpp/stash/deb/tmp dropkg
path: /home/mobile/dpp/stash/deb/tmpfound libhttp-tinyish-p5220.debdebian-binary/: Is a directory
tar: /home/mobile/dpp/stash/deb/tmp/control.tar.gz: Cannot open: No such file or directory
tar: Error is not recoverable: exiting now
tar: /home/mobile/dpp/stash/deb/tmp/data.tar.gz: Cannot open: No such file or directory
tar: Error is not recoverable: exiting now
rm: cannot remove ‘/home/mobile/dpp/stash/deb/tmp/control.tar.gz’: No such file or directory
rm: cannot remove ‘/home/mobile/dpp/stash/deb/tmp/debian-binary’: No such file or directory
rm: cannot remove ‘/home/mobile/dpp/stash/deb/tmp/data.tar.gz’: No such file or directory
.
```
**add support for other debian files ex: md5sums..**
