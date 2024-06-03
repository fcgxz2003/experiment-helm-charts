#!/bin/bash 
# 间隔120s 是方便grafana 找时间段的数据
sh tide.sh

sleep 120s

sh fig11/50pod_500M_random_epoch1.sh
sh fig11/50pod_1G_random_epoch1.sh
sh fig11/50pod_5G_random_epoch1.sh
sh fig11/50pod_10G_random_epoch1.sh

sleep 120s

sh fig11/50pod_500M_random_epoch2.sh
sh fig11/50pod_1G_random_epoch2.sh
sh fig11/50pod_5G_random_epoch2.sh
sh fig11/50pod_10G_random_epoch2.sh

sleep 120s

sh fig11/50pod_500M_random_epoch3.sh
sh fig11/50pod_1G_random_epoch3.sh
sh fig11/50pod_5G_random_epoch3.sh
sh fig11/50pod_10G_random_epoch3.sh

sleep 120s

sh fig11/50pod_500M_random_epoch4.sh
sh fig11/50pod_1G_random_epoch4.sh
sh fig11/50pod_5G_random_epoch4.sh
sh fig11/50pod_10G_random_epoch4.sh

rm /tmp/cost_random.csv
kubectl cp dragonfly-scheduler-0:/var/lib/dragonfly/cost.csv -n dragonfly-system /tmp/cost_random.csv

sleep 120s

sh fig12/10pod_500M_random.sh
sh fig12/30pod_500M_random.sh
sh fig12/50pod_500M_random.sh
sh fig12/100pod_500M_random.sh

sleep 120s

sh fig12/10pod_1G_random.sh
sh fig12/30pod_1G_random.sh
sh fig12/50pod_1G_random.sh
sh fig12/100pod_1G_random.sh

sleep 120s

sh fig12/10pod_5G_random.sh
sh fig12/30pod_5G_random.sh
sh fig12/50pod_5G_random.sh
sh fig12/100pod_5G_random.sh

sleep 120s

sh fig12/10pod_10G_random.sh
sh fig12/30pod_10G_random.sh
sh fig12/50pod_10G_random.sh
sh fig12/100pod_10G_random.sh

sleep 120s

sh fig14/10pod_random_preheat.sh
sh fig14/30pod_random_preheat.sh
sh fig14/50pod_random_preheat.sh
sh fig14/100pod_random_preheat.sh

sleep 120s
