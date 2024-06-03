#!/bin/bash 

pod="dragonfly-peer"
minio_address=$MINIO_ADDRESS
container="peer"
namespace="dragonfly-system"

mkdir -p ../fig14_output

# ------------------------------------ 没有预热
tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1308"

for i in $(seq 0 99);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -u $model >> "$tmp_dir/$i.txt" | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/100pod_random_preheat_0.txt"
touch ../fig14_output/100pod_random_preheat_0.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 0 99);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf 1G.bin?x=1308 &
done

wait
# ------------------------------------ 10个预热的结果
# 预热够30个
tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1309"

for i in $(seq 0 9);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -u $model &
done

wait

for i in $(seq 10 109);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -u $model >> "$tmp_dir/$i.txt" | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/100pod_random_preheat_10.txt"
touch ../fig14_output/100pod_random_preheat_10.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 0 109);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf 1G.bin?x=1309 &
done

wait
# ------------------------------------ 30个预热的结果
# 预热够30个
tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1310"

for i in $(seq 0 29);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -u $model &
done

wait

for i in $(seq 30 129);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -u $model >> "$tmp_dir/$i.txt" | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/100pod_random_preheat_30.txt"
touch ../fig14_output/100pod_random_preheat_30.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 0 129);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf 1G.bin?x=1310 &
done

wait
# ------------------------------------ 50个预热的结果
# 预热够50个
tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1311"

for i in $(seq 0 49);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -u $model &
done

wait

for i in $(seq 50 149);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -u $model >> "$tmp_dir/$i.txt" | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/100pod_random_preheat_50.txt"
touch ../fig14_output/100pod_random_preheat_50.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 0 149);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf 1G.bin?x=1311 &
done

wait
# ------------------------------------ 100个预热的结果
# 预热够100个,在0预热基础上，下载100个节点，当作预热了
tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1309"

for i in $(seq 100 199);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -u $model >> "$tmp_dir/$i.txt" | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/100pod_random_preheat_100.txt"
touch ../fig14_output/100pod_random_preheat_100.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 100 199);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf 1G.bin?x=1309 &
done

wait