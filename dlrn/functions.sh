

function target(){
    TAG=$1
    CENTOS_VERSION=centos${2:-9}
    if [ "$CENTOS_VERSION" = "centos10" ];then
        target="centos10"
    else
        target="centos9"
    fi

    config_path="/DLRN/projects.ini"
    baseurl="http://trunk.rdoproject.org/${CENTOS_VERSION}/"
    src="master"
    branch=""
    master_tag="epoxy-uc"

    if [[ "${TAG}" != "${master_tag}" ]]; then
        branch=$(echo $TAG | awk -F- '{print $1}')
        tag=$TAG
        baseurl="http://trunk.rdoproject.org/${branch}/${CENTOS_VERSION}/"
        src="stable/${branch}"
        distro="${TAG}-rdo"
    fi

    sed -i "s%target=.*%target=${target}%" $config_path
    sed -i "s%source=.*%source=${src}%" $config_path
    sed -i "s%baseurl=.*%baseurl=${baseurl}%" $config_path
    sed -i "s%tags=.*%tags=${tag}%" $config_path
    sed -i "s%distro=.*%distro=${distro}%" $config_path
    sed -i "s%use_components=.*%use_components=true%" $config_path
}

echo -e "First, target the release and CentOS version:"
echo -e "Example:     target epoxy-uc"
echo -e "             target epoxy-uc 10"
echo -e "             target dalmatian"
echo -e "             target caracal"
echo -e "             target bobcat"
echo -e "             target zed"
echo -e "Then, run DLRN:"
echo -e "             dlrn --head-only --dev --local --verbose-build --package-name openstack-tacker"
