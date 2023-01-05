if [ -f /run/secrets/bwrc.sh ]; then
    source /run/secrets/bwrc.sh
    if [ "$BW_SESSION" == "" ]; then
        BW_CLIENTID=$BW_CLIENTID BW_CLIENTSECRET=$BW_CLIENTSECRET bw login --apikey >/dev/null 2>&1
        bw_session=$(bw unlock --passwordenv BW_PASSWORD --raw)
        export BW_SESSION="$bw_session"
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
