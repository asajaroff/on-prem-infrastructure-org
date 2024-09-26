# Hypervisor0

## Initial setup
```
su -
apt update
apt install git 
```
# Setup debian as base host

### Install nvidia drivers
* Add `contrib non-free` to apt sources
* Install kernel headers: 
```bash
apt install linux-headers-amd64
```
* Install nvidia drivers
```bash
apt install nvidia-driver firmware-misc-nonfree
```

### Hypervisor

#### Xen project
Run
```bash
apt-get install xen-system-amd64
systemctl reboot

# LVM creation
fdisk -l # Identify partition to select
pvcreate /dev/nvme0n1p7
vgcreate vg0 /dev/nvme0n1p7
# To create a disk in this virtual group run:
# lvcreate -n <name of the volume> -L <size, you can use G and M here> vg0
```


## Hardware
### Dell XPS 9510
11e gen Intel® processors CORE™ I7 i7-11800H, 24 MB cache, 8 cores, 2,30 GHz tot 4,60 GHz

NVIDIA® GeForce® RTX 3050 Ti, 4 GB GDDR6

32 GB, 2 x 16 GB, DDR4, 3200 MHz, dual channel

1 TB, M.2 2280, PCIe NVMe, SSD


# How to Install Nvidia Drivers on Proxmox

1. Your `/etc/apt/sources.list` should look like this:
```bash
deb http://ftp.us.debian.org/debian bullseye main contrib non-free

deb http://ftp.us.debian.org/debian bullseye-updates main contrib non-free

# security updates
deb http://security.debian.org bullseye-security main contrib

# PVE pve-no-subscription repository provided by proxmox.com,
# NOT recommended for production use
deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription
```

2. `apt update`
3. `apt upgrade`
4. `apt install pve-headers`
5. `apt install libnvidia-cfg1 nvidia-kernel-source nvidia-kernel-common nvidia-driver`
6. Reboot
7. `nvidia-smi` should print something like this:
```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 470.141.03   Driver Version: 470.141.03   CUDA Version: 11.4     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA RTX A4000    On   | 00000000:42:00.0 Off |                  Off |
| 41%   44C    P8     7W / 140W |      1MiB / 16117MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```
