#!/usr/bin/env bash

# hardcoded headset MAC address (:
MAC="B0:F0:0C:4B:3B:45"
echo "trust $MAC" | bluetoothctl
echo "connect $MAC" | bluetoothctl
