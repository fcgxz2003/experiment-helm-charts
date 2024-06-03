#!/bin/bash 
# 间隔120s 是方便grafana 找时间段的数据
sh tide.sh

sleep 120s

sh fig11/50pod_500M_default_epoch1.sh
sh fig11/50pod_1G_default_epoch1.sh
sh fig11/50pod_5G_default_epoch1.sh
sh fig11/50pod_10G_default_epoch1.sh

sleep 120s

sh fig11/50pod_500M_default_epoch2.sh
sh fig11/50pod_1G_default_epoch2.sh
sh fig11/50pod_5G_default_epoch2.sh
sh fig11/50pod_10G_default_epoch2.sh

sleep 120s

sh fig11/50pod_500M_default_epoch3.sh
sh fig11/50pod_1G_default_epoch3.sh
sh fig11/50pod_5G_default_epoch3.sh
sh fig11/50pod_10G_default_epoch3.sh

sleep 120s

sh fig11/50pod_500M_default_epoch4.sh
sh fig11/50pod_1G_default_epoch4.sh
sh fig11/50pod_5G_default_epoch4.sh
sh fig11/50pod_10G_default_epoch4.sh

rm /tmp/cost_default.csv
kubectl cp dragonfly-scheduler-0:/var/lib/dragonfly/cost.csv -n dragonfly-system /tmp/cost_default.csv

sleep 120s

sh fig12/10pod_500M_default.sh
sh fig12/30pod_500M_default.sh
sh fig12/50pod_500M_default.sh
sh fig12/100pod_500M_default.sh

sleep 120s

sh fig12/10pod_1G_default.sh
sh fig12/30pod_1G_default.sh
sh fig12/50pod_1G_default.sh
sh fig12/100pod_1G_default.sh

sleep 120s

sh fig12/10pod_5G_default.sh
sh fig12/30pod_5G_default.sh
sh fig12/50pod_5G_default.sh
sh fig12/100pod_5G_default.sh

sleep 120s

sh fig12/10pod_10G_default.sh
sh fig12/30pod_10G_default.sh
sh fig12/50pod_10G_default.sh
sh fig12/100pod_10G_default.sh

sleep 120s

sh fig14/10pod_default_preheat.sh
sh fig14/30pod_default_preheat.sh
sh fig14/50pod_default_preheat.sh
sh fig14/100pod_default_preheat.sh

sleep 120s
