#!/bin/bash
TOOLBOX_DIR=${1:-.}
REGISTRY_NAMESPACE='quay.io/jcapitao'

function toolbox_create_volumes_hostdir(){
    for dir in $(grep -o -e '-v\ [^\ ]*/:' $TOOLBOX_DIR/README.md | awk '{print $2}' | cut -d: -f1 | sed "s|\$HOME|$HOME|g"); do
        mkdir -p "$dir"
    done
    for file in $(grep -o -e '-v\ [^\ ]*[^\/]:' $TOOLBOX_DIR/README.md | awk '{print $2}' | cut -d: -f1 | sed "s|\$HOME|$HOME|g"); do
        if [ ! -f $file ]; then
            touch $file
        fi
    done
}

function toolbox_pull_image_from_registry(){
    podman pull $REGISTRY_NAMESPACE/$1
}

function toolbox_pull_all_images_from_registry(){
    for image in `grep -o -e '[^\ ]*:latest' $TOOLBOX_DIR/README.md | uniq`; do
        toolbox_pull_image_from_registry $image
    done
}

function format_function(){
    toolbox_name=$1
    toolbox_run=$2
    echo -e "function $toolbox_name (){\n    $toolbox_run\n}" >> $TOOLBOX_DIR/.container.sh
}

function toolbox_create_dotfiles_secret(){
    read -p "Enter your BW_CLIENTID : " BW_CLIENTID
    read -sp "Enter your BW_CLIENTSECRET : " BW_CLIENTSECRET
    read -sp "Enter your BW_PASSWORD : " BW_PASSWORD
    rm bwrc.sh
    cat >> bwrc.sh<< EOF
export BW_CLIENTID='$BW_CLIENTID'
export BW_CLIENTSECRET='$BW_CLIENTSECRET'
export BW_PASSWORD='$BW_PASSWORD'
EOF
    podman secret rm bwrc.sh >/dev/null 2>&1
    podman secret create bwrc.sh bwrc.sh
    rm bwrc.sh
    podman secret ls | grep bwrc.sh
}

function toolbox_create_containerfunc(){
    echo -e "You need to enter your Bitwarden credential in order to pull dotfiles secret"
    rm -rf $TOOLBOX_DIR/.container.sh
    for image in `grep -o -e '[^\ ]*:latest' $TOOLBOX_DIR/README.md | uniq`; do
        arr=(${image//:/ })
        image_name=${arr[0]}
        run_cmd=$(grep -e "^podman run.*$image" $TOOLBOX_DIR/README.md)
        format_function $image_name "$run_cmd"
    done
    source $TOOLBOX_DIR/.container.sh
}

if [ -f $TOOLBOX_DIR/.container.sh ]; then
    source $TOOLBOX_DIR/.container.sh
fi
