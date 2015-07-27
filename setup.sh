#!/bin/bash

mkdir -p ./apps
mkdir -p ./apps/modules

# Clone the modules
MODULES=(
    'account'
)

for i in "${MODULES[@]}"
    do
    if [ ! -d apps/modules/$i.module.dev.mooti.com ]; then
        git clone git@github.com:mooti/mooti-module-$i.git ./apps/modules/$i.module.dev.mooti.com
    else
    	cd ./apps/modules/$i.module.dev.mooti.com
    	git pull
    	cd ../../..
    fi
done

# Clone support repos
APPS=(
    'xizlr-core'
)

for i in "${APPS[@]}"
    do
    if [ ! -d apps/$i ]; then
        git clone git@github.com:mooti/$i.git ./apps/$i
    else
    	cd ./apps/$i
    	git pull
    	cd ../..
    fi
done

# Start Vagrant
(vagrant status | grep running) || 
	vagrant up --provision

(vagrant status | grep poweroff) || 
	vagrant provision

#vagrant provision

for i in "${MODULES[@]}"
    do
    vagrant ssh -c "cd /vagrant/apps/modules/$i.module.dev.mooti.com && composer install"
done

for i in "${APPS[@]}"
    do
    vagrant ssh -c "cd /vagrant/apps/$i && composer install"
done
