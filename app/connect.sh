#!/bin/bash

ssh -i /data/id_rsa ec2-user@$1.$DEMO_PREFIX.$AWS_R53_DOMAIN
