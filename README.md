# Build Linux Kernel

```bash
sudo docker build -t linux_os .

sudo docker run --privileged -it linux_os

make menuconfig
# simply save

make -j8

mkdir /boot-os

cp arch/x86/boot/bzImage /boot-os/

cd ../busybox

make menuconfig
# go to setting && under Build options choose: Build static binary (no shared libs) && save 

make -j8

mkdir /boot-os/initramfs

make CONFIG_PREFIX=/boot-os/initramfs install

cd /boot-os/initramfs/

nano init

rm linuxrs

chmod +x init

find . | cpio -o -H newc > ../init.cpio
```

Setup of init file,

```bash
 #!/bin/sh
 /bin/sh
```

On the other terminal find running Docker container linux_os

```bash
sudo docker ps -a

# 123456 is CONTAINER ID 
```

Copy Linux Kernel snd init.cpio

```bash
sudo docker cp 6e62919338c3:/boot-os/bzImage .
sudo docker cp 6e62919338c3:/boot-os/init.cpio .
```

## Run Your Linux OS


```bash

#if you do not have qemu, install:

sudo apt install qemu-system-x86

# run Linux OS:

sudo qemu-system-x86_64 -kernel bzImage -initrd init.cpio
```

Confirm your current Linux Kernel:

```bash
uname -r
# e.g. 6.7.0-g5db8752
```

