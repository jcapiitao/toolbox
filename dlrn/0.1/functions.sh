

function target(){
    TAG=$1
    CENTOS_VERSION=centos${2:-9}
    if [ "$CENTOS_VERSION" = "centos8" ];then
        target="centos8-stream"
    else
        target="centos9"
    fi

    config_path="/DLRN/projects.ini"
    baseurl="http://trunk.rdoproject.org/${CENTOS_VERSION}/"
    src="master"
    branch=""
    tag="bobcat-uc"

    if [[ "${TAG}" != "bobcat-uc" ]]; then
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
echo -e "Example:     target bobcat-uc"
echo -e "             target zed 9"
echo -e "             target yoga 9"
echo -e "             target xena 8"
echo -e "Then, run DLRN:"
echo -e "             dlrn --head-only --dev --local --verbose-build --package-name openstack-tacker"
