# vivado-lcd16x2-helloworld

| License | Versioning |
| ------- | ---------- |
| [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) | [![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release) |

Simple LCD16x2 example.


## Preprequisites

* Git LFS.
* Target board: `digilentinc.com:arty-z7-20:part0:1.1`.
* Vivado 2021.2 and above.


## Getting Started

Clone this project and `cd` into the project root:
```
git clone https://github.com/extra2000/vivado-lcd16x2-helloworld.git
cd vivado-lcd16x2-helloworld
```


## Creating Vivado Project

From the project root directory, create contraint file using the following command:
```
cp -v vivado/src/constrs/artyz7-20.xdc{.example,}
```

Create project:
```
cd vivado/run/
flatpak run com.github.corna.Vivado -mode batch -source ../script/create_prj.tcl -notrace -tclargs --project_name lcd16x2-helloworld
```

Then, load the Vivado project:
```
flatpak run com.github.corna.Vivado -mode gui ./lcd16x2-helloworld/lcd16x2-helloworld.xpr
```

Generate XSA file required by Vitis and PetaLinux.


## Build PetaLinux

Fix permission issues:
```
chcon -R -v -t container_file_t ./petalinux ./vivado/run/lcd16x2-helloworld
podman unshare chown -R 1000:1000 ./petalinux
```

Create project:
```
podman run -it --rm -v ${PWD}/petalinux:${PWD}/petalinux:rw --workdir ${PWD}/petalinux --security-opt label=type:petalinux_builder.process localhost/extra2000/petalinux-builder:latest
petalinux-create --type project --template zynq --name arty-z7-20
exit
```

Build project:
```
podman run -it --rm -v ${PWD}/vivado:${PWD}/vivado:ro -v ${PWD}/petalinux:${PWD}/petalinux:rw --workdir ${PWD}/petalinux/arty-z7-20 --security-opt label=type:petalinux_builder.process localhost/extra2000/petalinux-builder:latest
petalinux-config --get-hw-description ../../vivado/run/lcd16x2-helloworld/
petalinux-build
petalinux-package --boot --fsbl ./images/linux/zynq_fsbl.elf --fpga ./images/linux/system.bit --u-boot
exit
```

Restore ownership:
```
podman unshare chown -R 0:0 ./petalinux/
```

Create SD card image.


## Diagrams

Schematic:

![schematics](docs/schematic.png)
