# mar/03/2017 12:47:19 by RouterOS 6.38.1
# software id = BJ9B-2NR5
#
/interface bridge
add name=bridge1
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-onlyn channel-width=20/40mhz-Ce \
    disabled=no frequency=auto hide-ssid=yes hw-retries=15 mode=ap-bridge \
    nv2-cell-radius=10 nv2-preshared-key=deadbeefdeadbeef nv2-security=\
    enabled preamble-mode=short ssid=AplAplAplApl tdma-period-size=10 \
    tx-power=0 tx-power-mode=all-rates-fixed wireless-protocol=802.11 \
    wps-mode=disabled
/interface ethernet
set [ find default-name=ether1 ] advertise=\
    100M-half,100M-full,1000M-half,1000M-full l2mtu=4076
/interface wireless nstreme
set wlan1 disable-csma=yes enable-nstreme=yes
/ip neighbor discovery
set wlan1 discover=no
/interface wireless security-profiles
set [ find default=yes ] authentication-types=wpa2-psk mode=dynamic-keys \
    supplicant-identity=MikroTik wpa-pre-shared-key=deadbeefdeadbeefdeadbeef \
    wpa2-pre-shared-key=deadbeefdeadbeef
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
/ip pool
add name=default-dhcp ranges=192.168.88.10-192.168.88.254
/interface bridge port
add bridge=bridge1 interface=wlan1
add bridge=bridge1 interface=ether1
/ip address
add address=192.168.17.5/24 comment=defconf interface=wlan1 network=\
    192.168.17.0
/ip dhcp-client
add comment=defconf dhcp-options=hostname,clientid disabled=no interface=\
    ether1
/ip dhcp-server network
add address=192.168.88.0/24 comment=defconf gateway=192.168.88.1
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.17.5 name=router
/ip firewall filter
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=accept chain=input comment="defconf: accept established,related" \
    connection-state=established,related
# in/out-interface matcher not possible when interface (wlan1) is slave - use master instead (bridge1)
add action=drop chain=input comment="defconf: drop all from WAN" \
    in-interface=wlan1
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" \
    connection-state=established,related
add action=accept chain=forward comment="defconf: accept established,related" \
    connection-state=established,related
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
# in/out-interface matcher not possible when interface (wlan1) is slave - use master instead (bridge1)
add action=drop chain=forward comment=\
    "defconf:  drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new in-interface=wlan1
/ip firewall nat
# in/out-interface matcher not possible when interface (wlan1) is slave - use master instead (bridge1)
add action=masquerade chain=srcnat comment="defconf: masquerade" \
    out-interface=wlan1
/system clock
set time-zone-name=America/Los_Angeles
/system identity
set name=Ren
/system leds
set 0 interface=wlan1
/system ntp client
set enabled=yes primary-ntp=192.168.17.4
/tool bandwidth-server
set authenticate=no
/tool graphing interface
add interface=wlan1
/tool graphing resource
add
/tool mac-server
set [ find default=yes ] disabled=yes
add interface=ether1
/tool mac-server mac-winbox
set [ find default=yes ] disabled=yes
add interface=ether1
