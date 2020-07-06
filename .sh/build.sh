#!/bin/bash
# script revised: Mon July 06, 2020 @ 05:08:06 EDT
echo "  "
echo "######################"
echo " build.sh"
echo "######################"
echo "  "
sudo cp -v $(git rev-parse --show-toplevel)/apc.conf /etc/httpd/sites-available/apc.conf
sudo cp -rv $(git rev-parse --show-toplevel)/pagesource/* /var/www/apc/html/
echo "  "
echo "--------------------"
echo "  "
echo "site [apc] built from pagesource ($(git rev-parse --show-toplevel)/pagesource/*)";
sudo systemctl reload httpd
echo "httpd reloaded."
echo "  "
echo "===================="
echo "  "
