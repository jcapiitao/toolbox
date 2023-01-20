# DLRN image
``` bash
podman build -t dlrn-toolbox:latest -f dlrn/Containerfile
podman run --privileged --userns=keep-id -v $HOME/workspace/dlrn-data/:/DLRN/data/ -v $HOME/workspace/dlrn-data/.bash_history:/home/dlrn/.bash_history --hostname dlrn -it quay.io/jcapitao/dlrn-toolbox:latest
```

# Vagrant image
``` bash
podman build -t vagrant-toolbox:latest -f vagrant/Containerfile
podman run --userns=keep-id --hostname vagrant -v $HOME/.openrc.sh:/home/vagrant/.openrc.sh -v $HOME/.ssh/:/home/vagrant/.ssh/ -v $HOME/workspace/vagrant-data/:/vagrant/.vagrant/ -it quay.io/jcapitao/vagrant-toolbox:latest
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
podman run --secret bwrc.sh --userns=keep-id --hostname dotfiles -v $HOME:/home/chezmoi/ -it quay.io/jcapitao/dotfiles-toolbox:latest
```
