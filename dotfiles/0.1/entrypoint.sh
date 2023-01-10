source /etc/profile.d/bwsession.sh
if [ ! -f $HOME/.ssh/id_ed25519 ]; then
    mkdir $HOME/.ssh >/dev/null
    chezmoi init https://gitlab.com/jcapitao/chezmoi-dotfiles
    chezmoi apply .ssh/id_ed25519 -c $HOME/.local/share/chezmoi/dot_config/chezmoi/chezmoi.toml
    chezmoi apply -c $HOME/.local/share/chezmoi/dot_config/chezmoi/chezmoi.toml
    pushd $HOME/.local/share/chezmoi/
    git remote set-url --push origin git@gitlab.com:jcapitao/chezmoi-dotfiles.git
    popd
fi
bash
