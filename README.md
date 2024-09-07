# My nixos config

This is my nixos config. It's intended for the use of 2 main devices and one raspberry pi 5. Support for kubernetes and multiple raspis is planned in near future.

## Project structure

- **hosts**\
  contain a basic setup for each host (e.g. notebook, pc, etc.)\
  the goal is to keep those configurations at a bare minimum and import everything thats needed from other modules

- **modules**\
  contain a basic setup for application and their configurations
  - **home**\
    contains setup for home-manager specific stuff

## Installation and setup

As this configuration utilizes flakes it is fairly simple to install and setup:

```bash
sudo nixos-rebuild switch --flake './#<host-name>'
```

### Updating the configuration

The following two commands are used to update 1. the nix flake and 2. the system.

If any error occurs when updating or building feel free to open an issue or a pr :)

```bash
sudo nix flake update
```

```bash
sudo nixos-rebuild switch --flake './#<host-name>'
```

For more information look at: [NixOS docs](https://nixos.wiki/wiki/flakes)

### Raspberry pi 5 Setup

There already is a great documentation [here](https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi_5).\
None the less a quick guide:

#### Requirements

Requirements are only needed for this guide, the process can be probably highly optimised but I found this
one the easiest approach

- Rpi5 (with peripherals (e.g. display and keyboard))
- SD card
- USB stick
- another machine

#### Setting up UEFI and the sd card

1. Create a gpt partition table
2. Create an efi (fat32) partition
3. Create a linux partition for nixos (could be done within the nixos installation step)
4. Format the partitions
   - fat32 for boot partition
   - ext4 for linux partition
5. Mount the boot partition
6. Look at this [repo](https://github.com/worproject/rpi5-uefi) and get the latest release
7. Copy the 3 files from the release into the boot partition
8. (Optional) Adjust the config.txt if needed
9. Insert the sd card into the raspi and check if the uefi menu shows up correctly (might need to hit esc)

#### Prepare the booting device

1. Get the [lates release](https://hydra.nixos.org/job/nixos/trunk-combined/nixos.iso_minimal_new_kernel_no_zfs.aarch64-linux)
   or look at this [guide](https://wiki.nixos.org/wiki/NixOS_on_ARM/UEFI)
2. Plug in the usb
3. Flash the iso onto the usb stick

#### Launch installation media

1. Plug the installation stick into your raspi
2. Boot the raspi
3. (Optional) Adjust any uefi settings if needed (e.g. boot order)
4. Launch nixos installation

#### Install nixos

Once this stage is reached you might also continue with the normal installation instructions.
Allthough there are a few options that have to be set:

```nix
  boot.loader.efi.canTouchEfiVariables = false;
```

```nix
  boot.kernelPackages = (import (builtins.fetchTarball https://gitlab.com/vriska/nix-rpi5/-/archive/main.tar.gz)).legacyPackages.aarch64-linux.linuxPackages_rpi5;
```

the second setting can also be implemented by using the flake directly like this config does.

When everything is in place hit nixos-install! Note: This might take a while

#### Post-Installation

This is really important in order to be able to boot nixos.

1. Open up the uefi by hitting esc.
2. Go into Device Manager -> Raspberry Pi Configuration -> ACPI / Device Tree -> System Table Mode
3. Change it from ACPI to Device Tree
   Once thats done, feel free to boot nixos!

After everything works and is correctly set up you might also revisit some guides and configs to ensure
that everything is set up as it should be. For example you might want to set `force_turbo=1` to `0`
in the `/boot/config.txt` file.

### Secure boot with lanzaboote

[Official Guide](https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md)

Secure is still experimental, but I found it to work quite well.
Here is a step by step introction:

1. `sudo sbctl create-keys`
2. Add lanzaboote to the nix config. (example in [boot.nix](./modules/boot.nix))
3. `sudo sbctl verify` and verify that the boot entries which are relevant are signed. 
4. Reboot into your UEFI/BIOS and enable SecureBoot and enable Boot Setup mode 
5. Boot the system and enroll the keys `sudo sbctl enroll-keys --microsoft`
6. Reboot the system (Boot Setup mode should be automagically disabled)
7. Check if everything is correctly setup with `bootctl status`

### disk encryption with nixos
Check out these 2 guides: [NixOS Wiki](https://nixos.wiki/wiki/Full_Disk_Encryption), [NixOS with encrypted root](https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134)\
A quick summary:
1. Get your nixos usb stick and boot up the installation media
2. Create the encrypted partition using `cryptsetup luksFormat /dev/sda2` and open it with `cryptsetup luksOpen /dev/sda2 enc-pv`
3. Create logical volumes on the created partition using pvcreate
   - `/dev/mapper/enc-pv`
   - `vgcreate vg /dev/mapper/enc-pv`
   - Create swap `lvcreate -L 8G -n swap vg`
   - Create root `lvcreate -l '100%FREE' -n root vg`
4. Format the partitions
   - `mkfs.fat /dev/sda1`
   - Format encrypted root volume `mkfs.ext4 -L root /dev/vg/root`
   - Format encrypted swap volume `mkswap -L swap /dev/vg/swap`
5. Mount the volumes
   - `mount /dev/vg/root /mnt`
   - `mkdir /mnt/boot`
   - `mount /dev/sda1 /mnt/boot`
   - `swapon /dev/vg/swap`
6. Proceed with the usual installation
> [!NOTE]
> Keep in mind when troubleshooting that the luks device needs to be open.
> Once created it can be opened with the second command mentioned in step 2.
> When working with the volumes keep in mind that the name doesn't match with the
> physical partition name, so just be sure to always use the provided name from
> the mapper!\
> There also is another setting for encrypted devices in the [boot.nix](./modules/boot.nix)
> file. It just ensures that the device is used and can safely be ignored due to automatic
> generation. (e.g. the same setting is set anyway in `hardware-configuration.nix`)


## Contribution guidelines

This repository uses [convetional commits](https://www.conventionalcommits.org/en/v1.0.0/#summary).<br/>
Just feel free to leave a PR and I might merge it! :D
