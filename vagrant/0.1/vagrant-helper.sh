if [ -f $HOME/.openrc.sh ]; then
    . $HOME/.openrc.sh
fi
pushd /vagrant >/dev/null
git pull -q
popd >/dev/null
