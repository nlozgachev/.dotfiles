function flushdns --description "Flush macOS DNS cache"
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
    echo "DNS cache flushed."
end
