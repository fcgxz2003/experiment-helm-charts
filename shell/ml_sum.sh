#!/bin/bash 
# 间隔120s 是方便grafana 找时间段的数据
sh tide.sh

sleep 120s

sh fig11/50pod_500M_ml_epoch1.sh
sh fig11/50pod_1G_ml_epoch1.sh
sh fig11/50pod_5G_ml_epoch1.sh
sh fig11/50pod_10G_ml_epoch1.sh

sleep 120s

sh fig11/50pod_500M_ml_epoch2.sh
sh fig11/50pod_1G_ml_epoch2.sh
sh fig11/50pod_5G_ml_epoch2.sh
sh fig11/50pod_10G_ml_epoch2.sh

sleep 120s

sh fig11/50pod_500M_ml_epoch3.sh
sh fig11/50pod_1G_ml_epoch3.sh
sh fig11/50pod_5G_ml_epoch3.sh
sh fig11/50pod_10G_ml_epoch3.sh

sleep 120s

sh fig11/50pod_500M_ml_epoch4.sh
sh fig11/50pod_1G_ml_epoch4.sh
sh fig11/50pod_5G_ml_epoch4.sh
sh fig11/50pod_10G_ml_epoch4.sh

rm /tmp/cost_ml.csv
kubectl cp dragonfly-scheduler-0:/var/lib/dragonfly/cost.csv -n dragonfly-system /tmp/cost_ml.csv

sleep 120s

sh fig12/10pod_500M_ml.sh
sh fig12/30pod_500M_ml.sh
sh fig12/50pod_500M_ml.sh
sh fig12/100pod_500M_ml.sh

sleep 120s

sh fig12/10pod_1G_ml.sh
sh fig12/30pod_1G_ml.sh
sh fig12/50pod_1G_ml.sh
sh fig12/100pod_1G_ml.sh

sleep 120s

sh fig12/10pod_5G_ml.sh
sh fig12/30pod_5G_ml.sh
sh fig12/50pod_5G_ml.sh
sh fig12/100pod_5G_ml.sh

sleep 120s

sh fig12/10pod_10G_ml.sh
sh fig12/30pod_10G_ml.sh
sh fig12/50pod_10G_ml.sh
sh fig12/100pod_10G_ml.sh

sleep 120s

sh fig14/10pod_ml_preheat.sh
sh fig14/30pod_ml_preheat.sh
sh fig14/50pod_ml_preheat.sh
sh fig14/100pod_ml_preheat.sh

sleep 120s
