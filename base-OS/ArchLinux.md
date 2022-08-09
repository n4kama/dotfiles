# Installation of Arch Linux

- [Installation of Arch Linux](#installation-of-arch-linux)
  - [Prerequisites](#prerequisites)
  - [Installation with `archinstall`](#installation-with-archinstall)
    - [`archinstall` procedure](#archinstall-procedure)
  - [Manual installation](#manual-installation)
    - [TODO](#todo)
    - [Install graphical environment](#install-graphical-environment)

## Prerequisites

- ISO of Arch Linux
- Toaster (or any kind of computer)

## Installation with `archinstall`

```bash
foo@bar:~$ loadkeys fr
foo@bar:~$ archinstall # Follow procedure below
```

### `archinstall` procedure

---
Among abvious settings, ensure these are set to :

- Profile : Xorg & graphic drivers
- Audio : Pipewire
- Network configuration : NetworkManager

## Manual installation

### TODO

FIXME

### Install graphical environment

 ```bash
 foo@bar:~$ sudo pacman -S xorg-server xorg-apps xorg-xinit
 ```