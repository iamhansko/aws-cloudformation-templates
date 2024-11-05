#!/bin/bash

# List EKS Addons
aws eks describe-addon-versions --query 'addons[].{name: addonName, latest_version: addonVersions[0].addonVersion, type: type}' --output table

