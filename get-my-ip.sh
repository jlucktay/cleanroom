#!/usr/bin/env bash
set -euo pipefail

PUBLIC_IP="$(dig +short myip.opendns.com @resolver1.opendns.com -4)"
jq --arg public_ip "$PUBLIC_IP" --null-input '{ "public_ip": $public_ip }'
