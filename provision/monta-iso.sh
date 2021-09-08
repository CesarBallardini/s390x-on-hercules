#!/usr/bin/env bash

UBUNTU_ISO_FILENAME=$1

sudo mkdir -p /mnt/iso
( mount | grep /mnt/iso 2>/dev/null ) || sudo mount -r -o loop /vagrant/tmp/${UBUNTU_ISO_FILENAME} /mnt/iso

