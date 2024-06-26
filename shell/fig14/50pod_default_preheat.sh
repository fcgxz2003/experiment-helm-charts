#!/bin/bash 

pod="dragonfly-peer"
minio_address=$MINIO_ADDRESS
container="peer"
namespace="dragonfly-system"

mkdir -p ../fig14_output

# ------------------------------------ 没有预热
tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1105"

for i in $(seq 0 49);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -u $model >> "$tmp_dir/$i.txt" | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/50pod_default_preheat_0.txt"
touch ../fig14_output/50pod_default_preheat_0.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 0 49);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf 1G.bin?x=1105 &
done

wait
# ------------------------------------ 10个预热的结果
# 先预热10个，再下载50个
tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1106"

for i in $(seq 0 9);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -u $model &
done

wait

for i in $(seq 10 59);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -u $model >> "$tmp_dir/$i.txt" | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/50pod_default_preheat_10.txt"
touch ../fig14_output/50pod_default_preheat_10.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 0 59);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf 1G.bin?x=1106 &
done

wait
# ------------------------------------ 30个预热的结果
# 预热够30个
tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1107"

for i in $(seq 0 29);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -u $model &
done

wait

tmp_dir=$(mktemp -d)

for i in $(seq 30 79);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -u $model >> "$tmp_dir/$i.txt" | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/50pod_default_preheat_30.txt"
touch ../fig14_output/50pod_default_preheat_30.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 0 79);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf 1G.bin?x=1107 &
done

wait
# ------------------------------------ 50个预热的结果
# 预热够50个，0预热已经下载了50，可以直接当作预热
tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1105"

for i in $(seq 50 99);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -u $model >> "$tmp_dir/$i.txt" | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/50pod_default_preheat_50.txt"
touch ../fig14_output/50pod_default_preheat_50.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 50 99);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf 1G.bin?x=1105 &
done

wait
# ------------------------------------ 100个预热的结果
# 预热够100个，50预热已经下载了100，可以直接当作预热
tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1105"

for i in $(seq 100 149);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -u $model >> "$tmp_dir/$i.txt" | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/50pod_default_preheat_100.txt"
touch ../fig14_output/50pod_default_preheat_100.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 100 149);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf 1G.bin?x=1105 &
done

wait