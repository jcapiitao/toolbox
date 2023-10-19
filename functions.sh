#!/bin/bash
TOOLBOX_DIR=$(dirname "$BASH_SOURCE")

function toolbox_create_volumes_hostdir(){
    for dir in $(grep -o -e '-v [^\ ]*/:' $TOOLBOX_DIR/README.md | awk '{print $2}' | cut -d: -f1 | sed "s|\$HOME|$HOME|g"); do
        mkdir -p "$dir"
    done
    for file in $(grep -o -e '-v [^\ ]*[^\/]:' $TOOLBOX_DIR/README.md | awk '{print $2}' | cut -d: -f1 | sed "s|\$HOME|$HOME|g"); do
        if [ ! -f $file ]; then
            touch $file
        fi
    done
}

function toolbox_pull_image_from_registry(){
    podman pull $1
}

function toolbox_pull_all_images_from_registry(){
    for image in `grep -o -e '[^\ ]*:latest' $TOOLBOX_DIR/README.md | grep -e "^quay" | uniq`; do
        toolbox_pull_image_from_registry $image
    done
}

function format_function(){
    toolbox_name=$1
    toolbox_run=$2
    cat >> $TOOLBOX_DIR/.container.sh<<EOF
function $toolbox_name (){
    podman ps -a | grep -e "$toolbox_name" | grep -q -i -e "created"
    if podman ps -a | grep -e "$toolbox_name" | grep -q -i -e "created"; then
        podman start $toolbox_name
        podman attach $toolbox_name
    elif podman ps -a | grep -e "$toolbox_name" | grep -q -i -e "Up"; then
        podman attach $toolbox_name
    else
        $toolbox_run
    fi
    }

EOF
}

function format_toolbox_enter(){
    toolbox_name=$1
    if [ "$toolbox_name" == "toolbox" ]; then
        toolbox_alias="tl"
    else
        toolbox_alias="$toolbox_name"
    fi
    cat >> $TOOLBOX_DIR/.container.sh<<EOF
function $toolbox_alias (){
    toolbox enter $toolbox_name
}

EOF
}

function toolbox_create_dotfiles_secret(){
    rm bwrc.sh >/dev/null
    echo -e "You need to enter your Bitwarden credential in order to pull dotfiles secret"
    read -p "Enter your BW_CLIENTID : " BW_CLIENTID
    read -sp "Enter your BW_CLIENTSECRET : " BW_CLIENTSECRET
    read -sp "Enter your BW_PASSWORD : " BW_PASSWORD
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
    rm -rf $TOOLBOX_DIR/.container.sh
    for image in `grep -o -e '[^\ ]*:latest' $TOOLBOX_DIR/README.md | grep -v -e "syncthing" -e "create" |  cut -d/ -f3- | uniq`; do
        arr=(${image//:/ })
        image_name=${arr[0]}
        run_cmd=$(grep -e "^podman run.*quay.io/jcapitao/$image" $TOOLBOX_DIR/README.md)
        if [ -n "$run_cmd" ]; then
            format_function $image_name "$run_cmd"
	else
            format_toolbox_enter $image_name
        fi
    done
    source $TOOLBOX_DIR/.container.sh
}

if [ -f $TOOLBOX_DIR/.container.sh ]; then
    source $TOOLBOX_DIR/.container.sh
fi
