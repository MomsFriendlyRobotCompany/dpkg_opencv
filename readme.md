# dpkg OpenCV

Unfortunately raspbian has old packages and the linux distro model is to move
slow and not update things. Unfortunately linux homebrew doesn't always work
(I use homebrew on macOS and it is awesome!) on liux.

## Package Setup

- DEBIAN
    - control (required)
    - templates (optional)
    - preinst (optional, chmod 0755)
    - postinst (optional, chmod 0755)
    - prerm (optional, chmod 0755)
    - postrm (optional, chmod 0755)

 where:

**preinst** – this script executes before that package will be unpacked from its Debian archive (“.deb”) file. Many ‘preinst’ scripts stop services for packages which are being upgraded until their installation or upgrade is completed (following the successful execution of the ‘postinst’ script).

**postinst** – this script typically completes any required configuration of the package foo once it has been unpacked from its Debian archive (“.deb”) file. Often ‘postinst’ scripts ask the user for input, and/or warn the user that if they accept the default values, they should remember to go back and re-configure that package as the situation warrants. Many ‘postinst’ scripts then execute any commands necessary to start or restart a service once a new package has been installed or upgraded.

**prerm** – this script typically stops any daemons which are associated with a package. It is executed before the removal of files associated with the package.

**postrm** – this script typically modifies links or other files associated with foo, and/or removes files created by the package.

## Build the Package

You should be able to use the package already built in this
repo, but if you want/need to build it:

	./build-opencv.sh
	./build-pkg.sh

## Check

You can double check your package with: `dpkg-deb --info <deb file>`

```bash
pi@zoidberg zeromq $ dpkg-deb --info zeromq-kevin.deb
 new debian package, version 2.0.
 size 4394058 bytes: control archive=553 bytes.
     269 bytes,     7 lines      control              
       6 bytes,     1 lines      install              
     153 bytes,    10 lines   *  postinst             #!/bin/bash
 Package: zeromq-kevin
 Architecture: all
 Maintainer: Kevin
 Depends: debconf (>= 0.5.00), libc6 (>= 2.7), libgcc1 (>= 1:4.4.0), libpgm-5.1-0 (>= 5.1.116~dfsg), libsodium13 (>= 0.6.0), libstdc++6 (>= 4.9)
 Priority: optional
 Version: 4.2.1
 Description: Kevins zmq library
 ```

## Install

  ./update-opencv.sh
	dpkg -i libopencv-kevin.deb

## References

 [Package setup details](https://www.leaseweb.com/labs/2013/06/creating-custom-debian-packages/)

 ---

 <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" align="middle"/></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
