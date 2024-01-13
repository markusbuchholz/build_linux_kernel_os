# Build Linux Kernel

This repository provides information about building a custom Linux distribution and covers both the technical understanding and practical implementation.

The steps include compiling the Linux kernel in a Docker container and integrating a minimalist environment using BusyBox. The system can be booted using [QEMU](https://www.qemu.org/).

The diagram below summarizes the methodology of creating a custom Linux distribution by leveraging the modularity of BusyBox and the Linux Kernel.


![image](https://github.com/markusbuchholz/build_linux_kernel_os/assets/30973337/3d05c4f2-71d6-413f-b1a4-6adad247c1bd)


The [Linux Kernel](https://github.com/torvalds/linux) is the primary component that manages the system's resources and facilitates communication between the hardware and software layers. It is responsible for critical aspects such as process management, memory handling, device I/O, and networking functionalities. In the context of a custom-built OS, the Linux Kernel can be fine-tuned during the compilation process to include only the necessary modules and drivers.

[BusyBox](https://busybox.net/) represents the user-space environment of the system and sits adjacent to the Linux Kernel. It is a collection of Unix utilities bundled into a single executable that provides a wide range of essential commands and tools for the system's operation. These utilities cover basic shell functions, file manipulation, system administration, and networking tasks. BusyBox is particularly well-suited for embedded systems or minimalist Linux distributions because of its design for space-saving and modularity. It offers the functionalities of a typical Linux command-line environment without the overhead of numerous standalone binaries.

The last component is [QEMU](https://www.qemu.org/), which sits as a virtualization layer beneath the custom Linux OS, enabling the system to run on top of a host operating system. QEMU is a powerful emulator that can run an OS for one machine on a different machine, virtualizing the hardware resources. This means that the custom Linux OS does not directly interact with the physical hardware of the host system. Instead, QEMU emulates the necessary hardware environment, allowing the custom OS to run as if it were on its intended hardware platform.


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

