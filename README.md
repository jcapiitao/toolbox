# DLRN image
``` bash
podman build -t dlrn:latest -f dlrn/Containerfile
podman run --privileged -v ~/workspace/dlrn-data:/DLRN/data --hostname dlrn -it dlrn:latest
```

# Vagrant image
``` bash
podman build -t vagrant:latest -f vagrant/Containerfile
podman run --hostname vagrant -v ~/.openrc.sh:/root/.openrc.sh -v ~/.ssh/:/root/.ssh/ -v ~/workspace/vagrant-data/:/vagrant/.vagrant -it vagrant:latest
```
