if [ -f /run/secrets/bwrc.sh ]; then
    source /run/secrets/bwrc.sh
    if [ "$BW_SESSION" == "" ]; then
        BW_CLIENTID=$BW_CLIENTID BW_CLIENTSECRET=$BW_CLIENTSECRET bw login --apikey >/dev/null
        if [ $? -ne 0 ]; then
            echo -e "ERROR: there were an issue while login to Bitwarden"
        fi
        bw_session=$(bw unlock --passwordenv BW_PASSWORD --raw)
        export BW_SESSION="$bw_session"
        bw sync
    fi
else
    echo "You must create the bwrc.sh with the bitwarden secret and pass it as arg with '--secret bwrc.sh'"
    echo ""
    echo "cat >> bwrc.sh<< EOF"
    echo "export BW_CLIENTID=''"
    echo "export BW_CLIENTSECRET=''"
    echo "export BW_PASSWORD=''"
    echo "EOF"
    echo "podman secret create bwrc.sh bwrc.sh"
    echo "podman run --secret bwrc.sh ..."
	exit 1
fi
