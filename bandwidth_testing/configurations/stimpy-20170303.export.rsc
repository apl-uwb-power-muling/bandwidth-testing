# mar/03/2017 20:47:07 by RouterOS 6.38.1
# software id = 0MHL-AVMB
#
/interface bridge
add name=bridge1
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-onlyn channel-width=20/40mhz-Ce \
    disabled=no frequency=auto hw-retries=15 mode=station-bridge \
    nv2-preshared-key=deadbeefdeadbeef nv2-security=enabled preamble-mode=\
    short ssid=AplAplAplApl tx-power=-5 tx-power-mode=all-rates-fixed
/interface wireless nstreme
set wlan1 enable-nstreme=yes
/ip neighbor discovery
set wlan1 discover=no
/interface wireless security-profiles
set [ find default=yes ] authentication-types=wpa2-psk mode=dynamic-keys \
    supplicant-identity=MikroTik wpa2-pre-shared-key=deadbeefdeadbeef
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
/ip pool
add name=default-dhcp ranges=192.168.88.10-192.168.88.254
/interface bridge port
add bridge=bridge1 interface=ether1
add bridge=bridge1 interface=wlan1
/interface wireless connect-list
add disabled=yes interface=wlan1 security-profile=default ssid=AplAplAplApl
/ip address
add address=192.168.17.6/24 comment=defconf interface=ether1 network=\
    192.168.17.0
/ip dhcp-client
add comment=defconf dhcp-options=hostname,clientid interface=wlan1
/ip dhcp-server network
add address=192.168.88.0/24 comment=defconf gateway=192.168.88.1
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.88.1 name=router
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
/system identity
set name=Stimpy
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
