#!/bin/bash
# Builder modified: Mon July 06, 2020 @ 05:21:20 EDT

if [[ $UID != 0 ]]; then
    echo "Please run this script using sudo: "
    echo "sudo $0 $1"
    exit 1
fi

confirm="no"
until [ "$confirm" = "yes" ]; do
    confirm="no";
    echo ""
    read -rp "Specify SiteName (eg. \"Google\"): " bld_sitename;
    inputgood="no";
    until [ "$inputgood" = "yes" ]; do
        read -rp "Specify Three-Letter Abbreviation (eg. \"goo\"): " bld_abbrev;
        if [ ${#bld_abbrev} = 3 ]; then
            inputgood="yes"
        else
            echo "ERR. Abbreviation must be three letters."
        fi
    done;
    echo "Just to confirm, you specified: ";
    echo "      sitename: $bld_sitename ";
    echo "      abbreviation: $bld_abbrev ";
    read -p "Is this correct? [Y/n] " response;
    response=${response,,};    # tolower
    if [[ "$response" =~ ^(yes|y)$ ]]; then
        confirm="yes";
    fi
done;
echo "";
echo "Creating Directories. Hold on to your seat!";
sudo mkdir -p /var/www/$bld_abbrev/html;
echo "      /var/www/$bld_abbrev/html created."
sudo mkdir -p /var/www/$bld_abbrev/logs;
echo "      /var/www/$bld_abbrev/logs created."
sudo mkdir -p /etc/httpd/sites-available;
sudo mkdir -p /etc/httpd/sites-enabled;
echo "      /etc/httpd/sites-* confirmed/created." 
echo "";
echo "Setting up permissions so SELinux doesn't throw a fit...";
echo " ~~~ What are you going to do SELinux? Cry? Piss your pants? Maybe shit and cum? ~~~ ";
sudo chown -R $USER:$USER /var/www/$bld_abbrev/html;
sudo chmod -R 755 /var/www;
sudo semanage fcontext -a -t httpd_log_t "/var/www/$bld_abbrev/logs(/.*)?";
sudo restorecon -R -v /var/www/$bld_abbrev/logs;
echo "";
echo "Reconfiguring Git environment.";
bld_self=$(git rev-parse --show-toplevel);
cd $bld_self/..;
sudo mkdir -p $bld_sitename;
sudo chown $USER:$USER $bld_sitename;
sudo cp -r $bld_self/* $bld_sitename;
sudo cp -r $bld_self/.sh $bld_sitname;
cd $bld_sitename;
mv apc.conf $bld_abbrev.conf
git init;
echo "";
echo "Writing configs.";
sed -i "s/apc/$bld_abbrev/g" $bld_abbrev.conf
sed -i "s/TEMPLATE/$bld_sitename/g" $bld_abbrev.conf
echo "";
echo "Generating default site.";
sudo mkdir -p pagesource/css;
mv index.html pagesource;
mv main.css pagesource/css;
cd pagesource/css;
(echo "/* AUTOGENERATED: $(date +'%c %Z') */" && cat main.css) > main1.css && mv main1.css main.css;
cd ..;
(echo "<!-- AUTOGENERATED: $(date +'%c %Z') -->" && cat index.html) > index1.html && mv index1.html index.html;
cd ..;
bld_self=$(git rev-parse --show-toplevel 2>&1);
echo "New root set at $bld_self";
cd $bld_self;
echo "";
echo "Building some luxuries.";
cd .sh;
echo "updating refs in $(pwd)/build.conf";
sed -i "s/apc/$build_abbrev/g" build.conf;
echo "updating refs in $(pwd)/clean.conf";
sed -i "s/apc/$build_abbrev/g" clean.conf;
echo "updating refs in $(pwd)/rebuild.conf";
sed -i "s/apc/$build_abbrev/g" rebuild.conf;
echo "updating refs in $(pwd)/flag-available.conf";
sed -i "s/apc/$build_abbrev/g" flag-available.conf;
echo "updating refs in $(pwd)/flag-unavailable.conf";
sed -i "s/apc/$build_abbrev/g" flag-unavailable.conf;
exit 0;
