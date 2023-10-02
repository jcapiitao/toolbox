# Fedora Sericea custom image

OCI image containing a bootable rpm-ostree, derived from [fedora-sericea](https://fedoraproject.org/sericea/).

## Status

[![Build my OS image](https://github.com/jcapiitao/toolbox/actions/workflows/build-and-push-os.yaml/badge.svg)](https://github.com/jcapiitao/toolbox/actions/workflows/build-and-push-os.yaml)

## Build instructions

```
podman build -t quay.io/jcapitao/os:latest .
podman push quay.io/jcapitao/os:latest
```

## Usage

On a rpm-ostree based system :
```
rpm-ostree rebase ostree-unverified-registry:quay.io/jcapitao/os:latest
```
