# redhub-common
Gentoo overlay for different programs.
Create issue when you need add apps, or if you found a bug. Pull requests are welcome.
Best ebuilds for best and most useful apps will move in main tree.

ADDED:
- twinkle
- Weblate client (CLI)
- zrtp for twinkle
- Regina-REXX

TODO:
- Weblate server
- Weblate CLI testing
- torrentpier
- pvpgn (maybe move to game overlay)
- veyon
- gitprep
- kamailio

How to use:

   1. Make sure you have installed package app-eselect/eselect-repository;
   2. Add custom repository, one of mirrors:
      - ```eselect repository add redhub-common git https://git.calculate-linux.org/ktrace/redhub-common.git```
      - ```eselect repository add redhub-common git https://gitflic.ru/project/redhub/redhub-common.git```
      - ```eselect repository add redhub-common git https://github.com/ktrace/redhub-stuff-overlay.git```
   3. Sync and update eix cache. Gentoo users may do ```eix-sync && eix-update```, Calculate Linux users must do ```emerge --sync && eix-update```.
   4. Check result by run ```eix twinkle```, your must see twinkle package and redhub-stuff overlay.
