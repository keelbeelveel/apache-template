#!/bin/bash
# script modified: Mon July 06, 2020 @ 05:09:17 EDT

sudo ln -s /etc/httpd/sites-available/apc.conf /etc/httpd/sites-enabled/apc.conf
echo "apc.conf has been symlinked into /etc/httpd/sites-enabled"
echo "Run ./flag-unavailable to remove this link."

