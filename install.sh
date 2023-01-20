#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/functions.sh

toolbox_create_volumes_hostdir
toolbox_pull_all_images_from_registry
toolbox_create_containerfunc

podman secret ls | grep -e "bwrc.sh" >/dev/null
if [ $? -ne 0 ]; then
    toolbox_create_dotfiles_secret
fi
