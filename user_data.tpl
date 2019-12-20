#!/bin/bash

sleep 3m

# Configure randomized password
echo -e '${bigip_passsword}\n${bigip_passsword}' | tmsh modify auth user admin prompt-for-password
tmsh save sys config

# Network connectivity test
count=0
while true
do
  STATUS=$(curl -s -k -I example.com | grep HTTP)
  if [[ $STATUS == *"200"* ]]; then
    echo "Got 200! VE is Ready!"
    break
  elif [ $count -le 6 ]; then
    echo "Status code: $STATUS network is not available yet."
    count=$[$count+1]
  else
    echo "Network Failure"
    break
  fi
  sleep 10
done

# Install Declarative Onboarding
do_pkg_url="https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.8.0/f5-declarative-onboarding-1.8.0-2.noarch.rpm"
do_pkg_path="/var/config/rest/downloads/declarative_onboarding.rpm"
do_json_pl="{\"operation\":\"INSTALL\",\"packageFilePath\":\"$do_pkg_path\"}"
curl -L -o $do_pkg_path $do_pkg_url
curl -k -u admin:${bigip_passsword} -X POST -d $do_json_pl "https://localhost/mgmt/shared/iapp/package-management-tasks"

sleep 20

# Send Declarative Onboarding Payload

cat << 'EOF' > /tmp/do_payload.json
{
    "schemaVersion": "1.5.0",
    "class": "Device",
    "async": true,
    "Common": {
        "class": "Tenant",
        "hostname": "demo-f5.example.com",
        "myLicense": {
            "class": "License",
            "licenseType": "licensePool",
            "bigIqHost": "${bigiq_server}",
            "bigIqUsername": "${bigiq_username}",
            "bigIqPassword": "${bigiq_password}",
            "licensePool": "${license_pool}",
            "skuKeyword1": "BT",
            "skuKeyword2": "10G",
            "unitOfMeasure": "yearly",
            "reachable": false,
            "hypervisor": "aws"
        },
        "myProvisioning": {
            "class": "Provision",
            "ltm": "nominal"
        },
        "external": {
            "class": "VLAN",
            "tag": 4092,
            "mtu": 1500,
            "interfaces": [
                {
                    "name": "1.2",
                    "tagged": false
                }
            ]
        },
        "internal": {
            "class": "VLAN",
            "tag": 4093,
            "mtu": 1500,
            "interfaces": [
                {
                    "name": "1.1",
                    "tagged": false
                }
            ]
        },
        "internal-self": {
            "class": "SelfIp",
            "address": "${internal_self_ip}/24",
            "vlan": "internal",
            "allowService": "none",
            "trafficGroup": "traffic-group-local-only"
        }
    }
}
EOF

curl -k -u admin:${bigip_passsword} -X POST -d @/tmp/do_payload.json "https://localhost/mgmt/shared/declarative-onboarding"


# Cleanup
rm -f /tmp/do_payload.json