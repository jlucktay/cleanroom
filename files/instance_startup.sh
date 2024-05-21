#!/usr/bin/env bash
set -euxo pipefail

### Install Docker and Git.
apt-get update
apt-get install --assume-yes --no-install-recommends docker.io git

### Only reboot once, the first time this startup script is executed.
metadata_url="http://metadata.goog/computeMetadata/v1/instance/guest-attributes/startup/rebooted"

startup_rebooted=$(curl --header "Metadata-Flavor: Google" "$metadata_url")

### If the reboot has already happened from a previous startup, then we're done.
if [[ $startup_rebooted == "TRUE" ]]; then
  exit 0
fi

### Otherwise, continue with first-time setup.
echo 'EXTRA_GROUPS="docker"' >> /etc/adduser.conf
echo 'ADD_EXTRA_GROUPS=1' >> /etc/adduser.conf

curl --data "TRUE" --header "Metadata-Flavor: Google" --request PUT "$metadata_url"

reboot
