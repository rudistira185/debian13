#!/system/bin/sh

NEW_SUBNET='192.168.50'
WIFI_INTERFACE='ap0'
WIFI_INTERFACE_INFO=$(ip addr show dev ${WIFI_INTERFACE} | grep -m1 "$WIFI_INTERFACE:")


if [[ "$WIFI_INTERFACE_INFO" == *"state UP"* ]]; then
    
    LOCAL_TABLE=$(awk '$2=="local_network" {print $1}' /data/misc/net/rt_tables)
    
    ip route replace ${NEW_SUBNET}.0/24 dev ${WIFI_INTERFACE} table $LOCAL_TABLE
    
    ip address replace ${NEW_SUBNET}.1/24 brd + dev ${WIFI_INTERFACE}
    
    IPADDR=$(ip addr show dev $WIFI_INTERFACE | awk -F '[ /\t]+' '$2=="inet"{print $3; exit}')
    IPROUTE=$(echo $IPADDR | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    
    if [[ "$IPROUTE" != *"$NEW_SUBNET"* ]]; then
        
        echo "$IPROUTE.0/24"
        ip route del ${IPROUTE}.0/24
        
        echo "$IPADDR/24"
        ip addr del ${IPADDR}/24 dev ${WIFI_INTERFACE}
        
    fi
    
    ndc interface clearaddrs ${WIFI_INTERFACE}
    ndc interface setcfg ${WIFI_INTERFACE} ${NEW_SUBNET}.1 24 up
    ndc network route add 99 ${WIFI_INTERFACE} ${NEW_SUBNET}.0/24
    
    exit 0
    
else
    
    echo "$WIFI_INTERFACE is DOWN!!!"
    exit 0
    
fi
