#!/bin/bash
echo "Running as $(whoami)"
bash <(curl -fsS https://packages.openvpn.net/as/install.sh) --as-version=2.14.2 --yes
ovpn-init --ec2 --batch --force
while [ ! -S /usr/local/openvpn_as/etc/sock/sagent ]; do
    sleep 1
done
/usr/local/openvpn_as/scripts/sacli -k 'vpn.server.daemon.ovpndco' -v 'true' ConfigPut
/usr/local/openvpn_as/scripts/sacli start
exit 0
license=${openvpn_license}
admin_pw=${openvpn_admin_pw}
