# VPN Proxy toggle with auto-start feature (Docker/Gluetun)

GLUETUN_COMPOSE_FILE="${HOME}/dockerfiles/wireguard/docker-compose.yml"

vpn_on() {
    echo "⏳ Checking Docker tunnel and Mullvad connection..."

    # Check if the container "taupinette" is running
    local CONTAINER_ID=$(docker ps -q -f name=^taupinette$)
    if [ -z "$CONTAINER_ID" ]; then
        echo "🚀 Container 'taupinette' is not running. Starting it now..."
        docker compose -f "$GLUETUN_COMPOSE_FILE" up -d
        
        echo "⏳ Waiting 4 seconds for the handshake..."
        sleep 4
    fi

    # Strict test (max 3s) through the local proxy
    local CHECK_RESPONSE=$(curl -s --max-time 3 -x http://127.0.0.1:8888 https://am.i.mullvad.net/json || echo '{"mullvad_exit_ip": false, "ip": "N/A", "city": "N/A"}')
    local IS_MULLVAD CURRENT_IP CITY
    
    {
        read -r IS_MULLVAD
        read -r CURRENT_IP
        read -r CITY
    } <<< "$(echo "$CHECK_RESPONSE" | jq -r '.mullvad_exit_ip, .ip, .city')"

    if [ "$IS_MULLVAD" = "true" ]; then
        
        # Export proxy variables for the current terminal
        export http_proxy="http://127.0.0.1:8888"
        export https_proxy="http://127.0.0.1:8888"
        export HTTP_PROXY="http://127.0.0.1:8888"
        export HTTPS_PROXY="http://127.0.0.1:8888"
        export no_proxy="0.0.0.0,localhost,127.0.0.1"
        export NO_PROXY="0.0.0.0,localhost,127.0.0.1"
        
        # Modify prompt (PS1) to indicate VPN is active
        export PS1_OLD=$PS1
        export PS1="[🌍 VPN] $PS1"
        
        echo "✅ Success! VPN Proxies ENABLED."
        echo "🌍 Secure IP: $CURRENT_IP ($CITY)"
        
    else
        echo "❌ ERROR: Security test failed!"
        echo "👉 The VPN container might be failing to connect to Mullvad."
        echo "⚠️  For your safety, proxies were NOT enabled on this terminal."
    fi
}

vpn_off() {
    # Clean up variables
    unset http_proxy
    unset https_proxy
    unset HTTP_PROXY
    unset HTTPS_PROXY
    unset no_proxy
    unset NO_PROXY
    
    # Restore original prompt
    if [ -n "$PS1_OLD" ]; then
        export PS1=$PS1_OLD
        unset PS1_OLD
    fi
    
    echo "🔓 VPN Proxies DISABLED. Back to normal direct connection."
}

# Bonus: Command to completely shut down the Docker containers when you're done for the day
vpn_stop() {
    echo "🛑 Stopping the VPN Docker containers..."
    docker compose -f "$GLUETUN_COMPOSE_FILE" down --remove-orphans
    # Also turn off the proxy variables if they were active in this terminal
    vpn_off > /dev/null 2>&1
}
