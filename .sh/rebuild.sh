#!/bin/bash
# Script modified: Tue June 30, 2020 @ 05:58:03 EDT
$(git rev-parse --show-toplevel)/.sh/clean.sh 
$(git rev-parse --show-toplevel)/.sh/build.sh
sudo systemctl reload httpd
