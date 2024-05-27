#!/bin/bash 

sh test/1epoch.sh
sh test/2epoch.sh
sh test/3epoch.sh
sh test/4epoch.sh

kubectl cp dragonf-ulg1d8-dragonfly-scheduler-0:/var/lib/dragonfly/cost.csv /tmp/cost_ml.csv -n d7y
