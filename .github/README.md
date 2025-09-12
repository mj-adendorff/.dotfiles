# 🗃️ .dotfiles

Configuration files for my Linux setup
These are my personal preferences based on a CachyOS arch linux distro.

## CachyOS kernel setup
The following kernels work best on my laptop and PC and I switch between them depending on the
day's usage. Best is to install through CachyOS's kernel manager.
- linux-cachyos-eevdf-lto
- linux-cachyos-hardened-lto

Plymouth has issues in my laptop which causes the splash screen to hang so I disable the splash screens
```bash
sudo su
vim /boot/loader/entries/linux-cachyos-*.conf
```
and remove the `splash` command line argument from kernel parameters

Also for my gaming PC in which I dual boot, I tend to turn on the timout to 300s, so that if I start my PC and come back to it, it hasn't auto-started the wrong OS.
```
vim /boot/loader/loader.conf
----
timeout 300
----
```

## Hyprland
