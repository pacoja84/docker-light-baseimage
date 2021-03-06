#!/bin/bash -e

# download curl and ca-certificate from apt-get if needed
to_install=""

if [ $(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
  to_install="curl"
fi

if [ $(dpkg-query -W -f='${Status}' ca-certificates 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
  to_install="$to_install ca-certificates"
fi

if [ -n "$to_install" ]; then
  LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $to_install
fi

# download libltdl-dev from apt-get
LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libltdl-dev

curl -o /usr/sbin/cfssl -SL https://github.com/osixia/cfssl/raw/master/bin/cfssl
chmod 700 /usr/sbin/cfssl

curl -o /usr/sbin/cfssljson -SL https://github.com/osixia/cfssl/raw/master/bin/cfssljson
chmod 700 /usr/sbin/cfssljson

# remove tools installed to download cfssl
if [ -n "$to_install" ]; then
  apt-get remove -y --purge --auto-remove $to_install
fi
