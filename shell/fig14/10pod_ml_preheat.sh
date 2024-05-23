#!/bin/bash 

pod="dragonfly-peer"
minio_address=$MINIO_ADDRESS
container="peer"
namespace="dragonfly-system"

mkdir -p ../fig14_output

# ------------------------------------ 没有预热
tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1002"

for i in $(seq 0 9);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model  >> "$$tmp_dir/$i.txt" | echo "peer-$i download model"  &
done

wait

output_file="../fig14_output/10pod_ml_preheat_0.txt"
touch ../fig14_output/10pod_ml_preheat_0.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

# ------------------------------------ 10个预热的结果

tmp_dir=$(mktemp -d)

for i in $(seq 10 19);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model  >> "$$tmp_dir/$i.txt" | echo "peer-$i download model"  &
done

wait

output_file="../fig14_output/10pod_ml_preheat_10.txt"
touch ../fig14_output/10pod_ml_preheat_10.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

# ------------------------------------ 30个预热的结果

# 预热够30个
for i in $(seq 20 29);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model &
done

wait

tmp_dir=$(mktemp -d)

for i in $(seq 30 39);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model  >> "$tmp_dir/$i.txt" | echo "peer-$i download model"  &
done

wait

output_file="../fig14_output/10pod_ml_preheat_30.txt"
touch ../fig14_output/10pod_ml_preheat_30.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

# ------------------------------------ 50个预热的结果

# 预热够50个
for i in $(seq 40 49);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model &
done

wait

tmp_dir=$(mktemp -d)

for i in $(seq 50 59);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model  >> "$$tmp_dir/$i.txt" | echo "peer-$i download model"  &
done

wait

output_file="../fig14_output/10pod_ml_preheat_50.txt"
touch ../fig14_output/10pod_ml_preheat_50.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

# ------------------------------------ 100个预热的结果

# 预热够100个
for i in $(seq 60 99);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model &
done

wait

tmp_dir=$(mktemp -d)

for i in $(seq 100 109);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model  >> "$$tmp_dir/$i.txt" | echo "peer-$i download model"  &
done

wait

output_file="../fig14_output/10pod_ml_preheat_100.txt"
touch ../fig14_output/10pod_ml_preheat_100.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"
