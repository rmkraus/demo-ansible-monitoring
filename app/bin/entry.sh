#!/bin/bash

export TF_DATA_DIR=/data/terraform
export TF_INPUT=0
export TF_IN_AUTOMATION=1

if [ ! -e /data/config.sh ]; then
  cp /data.skel/config.sh /data/config.sh
fi

if [ ! -e /data/tower_license.txt ]; then
  cp /data.skel/tower_license.txt /data/tower_license.txt
fi

if [ ! -d /data/terraform ]; then
  terraform init tf
fi

/bin/bash
