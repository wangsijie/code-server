#!/bin/bash
if [ -f "/etc/v2ray/config.json" ]; then
    export http_proxy=http://127.0.0.1:1080
    export https_proxy=http://127.0.0.1:1080
    export all_proxy=socks5://127.0.0.1:1081
    /usr/local/v2ray/v2ray --config=/etc/v2ray/config.json > v2ray.log &
    sleep 3
fi