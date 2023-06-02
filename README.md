# DLRN image
``` bash
podman build -t dlrn-toolbox:latest -f dlrn/Containerfile
podman run --privileged --userns=keep-id -v $HOME/workspace/dlrn-data/:/DLRN/data/:Z -v $HOME/workspace/dlrn-data/.bash_history:/home/dlrn/.bash_history:Z --hostname dlrn -it quay.io/jcapitao/dlrn-toolbox:latest
```

# Vagrant image
``` bash
podman build -t vagrant-toolbox:latest -f vagrant/Containerfile
podman run --userns=keep-id --hostname vagrant-toolbox -v $HOME/.openrc.sh:/home/vagrant/.openrc.sh -v $HOME/.ssh/:/home/vagrant/.ssh/ -v $HOME/workspace/vagrant-data/:/vagrant/.vagrant/:Z -it quay.io/jcapitao/vagrant-toolbox:latest
```

# Dotfiles image
``` bash
podman build -t dotfiles-toolbox:latest -f dotfiles/Containerfile
cat >> bwrc.sh<< EOF
export BW_CLIENTID=''
export BW_CLIENTSECRET=''
export BW_PASSWORD=''
EOF
podman secret create bwrc.sh bwrc.sh
podman run --name dotfiles-toolbox --userns=keep-id --secret bwrc.sh --hostname dotfiles -v $HOME/.dotfiles:/root/:z --rm -it quay.io/jcapitao/dotfiles-toolbox:latest
```
Note: I don't mount my entire home directory but only `$HOME/.dotfiles` and then I create symlinks. The main reason is to not have to SELinux relabel the whole home directory.

# Syncthing image
``` bash
podman create --name syncthing --network=host --userns=keep-id -p 8384:8384 -p 22000:22000/tcp -p 22000:22000/udp -p 21027:21027/udp -v /var/home/jcapitao/.config/syncthing:/var/syncthing/config:Z -v /var/home/jcapitao/Documents/:/home/jcapitao/Documents:Z -v /var/home/jcapitao/devices/:/home/jcapitao/devices:Z --hostname=syncthing docker.io/syncthing/syncthing:latest
# From https://www.redhat.com/sysadmin/podman-run-pods-systemd-services
cd $HOME/.config/systemd/user
podman generate systemd --new --files -n syncthing
systemctl --user daemon-reload
systemctl --user start container-syncthing.service
systemctl --user is-active container-syncthing.service
```
