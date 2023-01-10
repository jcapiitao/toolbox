# DLRN image
``` bash
podman build -t dlrn-toolbox:latest -f dlrn/Containerfile
podman run --privileged -v $HOME/workspace/dlrn-data/:/DLRN/data/ --hostname dlrn -it dlrn-toolbox:latest
```

# Vagrant image
``` bash
podman build -t vagrant-toolbox:latest -f vagrant/Containerfile
podman run --hostname vagrant -v $HOME/.openrc.sh:/root/.openrc.sh -v $HOME/.ssh/:/root/.ssh/ -v $HOME/workspace/vagrant-data/:/vagrant/.vagrant/ -it vagrant-toolbox:latest
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
podman run --secret bwrc.sh --userns=keep-id --hostname dotfiles -v $HOME:/home/chezmoi/ -it dotfiles-toolbox:latest
```
