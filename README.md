# The DPDK Stats
## Description
A small DPDK application that increments a basic packet counter for TCP or UDP packets depending on what's specified in the command line (UDP is default). The amount of packets per second is outputted on a new line each second and total packets is outputted before the program exits.

Dropped and forward (TX) mode is supported (dropped mode is default). When TX is specified in the command line, the source and destination MAC and IP addresses are swapped along with the TCP/UDP ports. Afterwards, the packet is forwarded.

This repository uses my DPDK Common [project](https://github.com/gamemann/The-DPDK-Common) in an effort to make things simpler.

## Requirements
* [The DPDK](https://dpdk.org) - Intel's Data Plane Development Kit which acts as a kernel bypass library which allows for fast network packet processing (one of the fastest libraries out there for packet processing).
* [The DPDK Common](https://github.com/gamemann/The-DPDK-Common) - A project written by me aimed to make my DPDK projects simpler to setup/run (included as a submodule to this project).

## Building The DPDK
If you want to build the DPDK using default options, the following should work assuming you have the requirements such as `ninja` and `meson`.

```
git clone https://github.com/DPDK/dpdk.git
cd dpdk/
meson build
cd build
ninja
sudo ninja install
sudo ldconfig
```

All needed header files from the DPDK will be stored inside of `/usr/local/include/`.

You may receive `ninja` and `meson` using the following.

```
sudo apt update
sudo apt install python3 python3-pip
sudo pip3 install meson # Pip3 is used because 'apt' has an outdated version of Meson usually.
sudo apt install ninja-build
```

## Building This Project
You may use `git` and `make` to build and install this application.

```
git clone --recursive https://github.com/gamemann/The-DPDK-Stats.git
cd The-DPDK-Stats/
make
sudo make install
```

The `dpdk-stats` executable will be available inside the `build/` directory. If you use `sudo make install`, it will be installed to `/usr/bin/` which should be in your `$PATH`. Therefore, you can simply run the application with `dpdk-stats` from any directory.

## EAL Parameters
This application supports DPDK's EAL paramters. These may be found [here](http://doc.dpdk.org/guides/linux_gsg/linux_eal_parameters.html).

This is useful for specifying the amount of l-cores and ports to configure for example.

## Command Line
The following command line options are available.

```
-p --portmask => The port mask to configure (e.g. 0xFFFF).
-P --portmap => The port map to configure (in '(x, y),(b,z)' format).
-q --queues => The amount of RX and TX queues to setup per port (default and recommended value is 1).
-x --promisc => Whether to enable promiscuous on all enabled ports.
-t --tx => Forward packets instead of dropping them.
-z --tcp => Only count TCP packets instead of UDP.
```

Here is an example.

```
dpdk-stats -l 0-1 -n 1 -- -q 1 -p 0xff -t
```

## Credits
* [Christian Deacon](https://github.com/gamemann)