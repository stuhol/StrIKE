# StrIKE - Deploy Strongswan for use with native platform VPN clients

**WARNING: This is still very much work in progress**

Strongswan is a great IPsec VPN but it can be difficult to deploy quickly. The idea behind StrIKE is to make it easier to deploy a VPN gateway for road warriors, complete with configurations which work with a platform's native VPN client.

At the moment there is a selection of scripts which downloads and installs Strongswan and some basic configurations. There is also a Dockerfile which can used to provision a Docker container and install StrIKE automatically. I chose to keep the Docker container as self contained as possible meaning it can be deployed and left to build, configure, and generate certificates for Strongswan within the container itself.

In the future I plan to develop a web application "StrIKE Dashboard" that makes certificate generation and profile configuration easy with status reporting.

Below is a description of each component of StrIKE.

## Build scripts

Located in the build directory these scripts download and build Strongswan on Alpine (master branch) or Ubuntu (ubuntu branch)

## Docker conatiner

The Docker container is based on Alpine Linux. Once we've booted into Alpine we do the following:

0. Install required packages to download the StrIKE repo
0. Download and extract the latest version of Strongswan.
0. Configure, compile, and install Strongswan.
0. Automatically generate CA certificate, self-signed gateway certificate, and client certificate.
0. (Coming soon) Install default configurations to work with the following platforms:
..* Mac OS
..* Windows 10
..* iOS
..* Android
0. Expose UDP ports 500/udp, 4500/udp, and 8000/tcp
0. (Coming soon) Start Strongswan

## Configuration

### Gateway Connection configurations

Coming soon.

### Client configurations

Coming soon. Client configuration profiles or tools to make the configuration of clients easy.

## StrIKE Helper

Coming soon. A helper which runs on the server to make installation, configuration, and certificate generation easy.

Currently there is a simple HTTP server which serves the client certificates so they can be downloaded easily from the Docker container.
