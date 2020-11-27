# QEMU Buildbot

Build QEMU for Linux (AppImage format). Currently `qemu-system-riscv32` and `qemu-system-riscv64` is provided.

[![Build Status](https://dev.azure.com/nekomimiswitch/General/_apis/build/status/qemu-buildbot-linux?branchName=master)](https://dev.azure.com/nekomimiswitch/General/_build/latest?definitionId=90&branchName=master)

## Building

Use a CentOS 7 docker container with FUSE.

## Usage

Execute directly with the first argument being the executable name you want to call:
```
chmod +x qemu.AppImage
./qemu.AppImage qemu-system-riscv32  -machine gd32vf103_rvstar -nographic -kernel helloworld.elf
```

or use its multicall capability:
```
chmod +x qemu.AppImage
ln -s qemu.AppImage qemu-system-riscv32
./qemu-system-riscv32  -machine gd32vf103_rvstar -nographic -kernel helloworld.elf
```
