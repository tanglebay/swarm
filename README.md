<h1 align="center">
SWARM
</h1>

<p align="center">
SWARM is a script that allows you to easily install and manage an IOTA node. The most important configuration options are given via simple and selectable menu items. About the additional feature "Watchdog", the status of the nodes can be monitored, as well as automatically install updates. A reverse proxy installation is also offered for secure access via HTTPS.
</p>

<p align="center">
    <a href="https://twitter.com/TANGLEBAY" style="text-decoration:none;"><img src="https://img.shields.io/badge/Twitter-9cf.svg?logo=twitter" alt="Twitter"></a>
    <a href="https://discord.tanglebay.com/" style="text-decoration:none;"><img src="https://img.shields.io/badge/Discord-9cf.svg?logo=discord" alt="Discord"></a>
</p>

---

## Installation

### Requirements
- VPS (2Core/4GB/40GB) **(RPi 4 is not supported for GoShimmer)**
- Ubuntu 20.04 LTS (64Bit)
- An existing (own) domain

**Download the latest release version of SWARM and run it. Do the following steps:**

1. Install SWARM with the Installer
```shell
curl -sL https://raw.githubusercontent.com/tanglebay/swarm/master/installer.sh | sudo bash -
```
2. After installting SWARM you can execute it with typing `swarm`

**Notice**: Please make sure that your node is properly secured (e.g. firewall, SSH KeyAuth, regular system updates).

## Ports
### Hornet
- Gossip: `15600/tcp`
- Autopeering: `14626/udp`
- API (HTTPS): `443/tcp`
- HTTP (letsencrypt): `80/tcp`
### GoShimmer
- Gossip: `14666/tcp`
- Autopeering: `14626/udp`
- API (HTTPS): `443/tcp`
- HTTP (letsencrypt): `80/tcp`


## Backup SWARM
If you ever want to reinstall your server or SWARM, you can backup your SWARM configuration first.

You can find the configuration files under the following path:
```shell
cd /var/lib/swarm/configs
```

After the reinstallation, simply replace the configurations with your backup, run a SWARM update to update the configuration files (if necessary) and then you can reinstall Hornet and the proxy and have all settings imported directly.

## Disclaimer

**Please note that you use this script at your own risk and that I will not be liable for any damages that may occur**

---

## Tips

**IOTA Address:**
```
iota1qq2zpclw655gaxun5ruzlnpmpqccem5v47xvc8ptkms260csz2m5ymuesea
```