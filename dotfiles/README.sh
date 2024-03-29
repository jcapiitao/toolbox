function help(){
    echo "Pull the latest changes from your repo and apply them"
    echo ""
    echo "          chezmoi update"
    echo ""
    echo "This can be done in 2 steps too:"
    echo "(1/2) Pull the latest changes from your repo and see what would change, without actually applying the changes:"
    echo ""
    echo "          chezmoi git pull -- --autostash --rebase && chezmoi diff"
    echo ""
    echo "(2/2) If you're happy with the changes, then you can run"
    echo ""
    echo "          chezmoi apply"
    echo ""
    echo "Add new changes"
    echo ""
    echo "          chezmoi add <file>"
    echo "          chezmoi cd"
    echo "          git status"
    echo "          git add <file> && git commit -m '' && git push"
    echo ""
    echo "Syncing BitWarden - Pull the latest vault data from server"
    echo ""
    echo "          bw sync"
    echo ""
}
help
