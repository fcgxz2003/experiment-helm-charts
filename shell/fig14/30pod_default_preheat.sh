#!/bin/bash 

pod="dragonfly-peer"
minio_address=$MINIO_ADDRESS
container="peer"
namespace="dragonfly-system"

mkdir -p ../fig14_output

# ------------------------------------ 没有预热
tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1103"

for i in $(seq 0 29);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model  >> "$tmp_dir/$i.txt" | echo "peer-$i download model"  &
done

wait

output_file="../fig14_output/30pod_default_preheat_0.txt"
touch ../fig14_output/30pod_default_preheat_0.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 0 29);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf /test &
done

wait
# ------------------------------------ 10个预热的结果
# 重新预热一个模型，预热10个Pod
tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1104"

for i in $(seq 0 9);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model &
done

wait

for i in $(seq 10 39);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model >> "$tmp_dir/$i.txt" | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/30pod_default_preheat_10.txt"
touch ../fig14_output/30pod_default_preheat_10.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 0 39);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf /test &
done

wait
# ------------------------------------ 30个预热的结果
# 预热够30个，预热0个时候，下载的30个当作预热好的
tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1103"

for i in $(seq 30 59);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model >> "$tmp_dir/$i.txt" | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/30pod_default_preheat_30.txt"
touch ../fig14_output/30pod_default_preheat_30.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 30 59);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf /test &
done

wait
# ------------------------------------ 50个预热的结果
# 预热够50个，在预热10个，下载30个的基础上，再预热多10个就够了

tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1104"

for i in $(seq 40 49);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model &
done

wait

for i in $(seq 50 79);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model >> "$tmp_dir/$i.txt" | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/30pod_default_preheat_50.txt"
touch ../fig14_output/30pod_default_preheat_50.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 40 79);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf /test &
done

wait
# ------------------------------------ 100个预热的结果
# 预热够100个，在预热50个，下载30个的基础上，再预热多20个就够了

tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1104"

for i in $(seq 80 99);do
   kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model &
done

wait

for i in $(seq 100 129);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model >> "$tmp_dir/$i.txt" | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/30pod_default_preheat_100.txt"
touch ../fig14_output/30pod_default_preheat_100.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 80 129);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf /test &
done

wait