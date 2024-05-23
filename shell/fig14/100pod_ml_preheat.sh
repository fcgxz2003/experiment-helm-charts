#!/bin/bash 

pod="dragonfly-peer"
minio_address=$MINIO_ADDRESS
model="http://$minio_address/models/10G.bin?x=1005"
container="peer"
namespace="dragonfly-system"

mkdir -p ../fig14_output

command_preheat(){
  kubectl exec -it $pod-$1 -c peer -n $namespace -- dfget -o /test -u $model
}

command() {
  kubectl exec -it $pod-$1 -c peer -n $namespace -- dfget -o /test -u $model  >> "$2/$1.txt" &
}

command_delete() {
  kubectl exec -it $pod-$1 -c peer -n $namespace -- rm -rf /test
}

# ------------------------------------ 没有预热
tmp_dir=$(mktemp -d)

for i in $(seq 0 29);do
  command $i $tmp_dir | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/30pod_ml_preheat_0.txt"
touch ../fig14_output/30pod_ml_preheat_0.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

# ------------------------------------ 10个预热的结果

tmp_dir=$(mktemp -d)

for i in $(seq 10 19);do
  command $i $tmp_dir| echo "peer-$i download model" &
done

wait

output_file="../fig14_output/30pod_ml_preheat_10.txt"
touch ../fig14_output/30pod_ml_preheat_10.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

# ------------------------------------ 30个预热的结果
# 预热够30个

for i in $(seq 20 29);do
  command_preheat $i &
done

wait

tmp_dir=$(mktemp -d)

for i in $(seq 30 39);do
  command $i $tmp_dir| echo "peer-$i download model" &
done

wait

output_file="../fig14_output/30pod_ml_preheat_30.txt"
touch ../fig14_output/30pod_ml_preheat_30.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

# ------------------------------------ 50个预热的结果
# 预热够50个

for i in $(seq 40 49);do
  command_preheat $i &
done

wait

tmp_dir=$(mktemp -d)

for i in $(seq 50 59);do
  command $i $tmp_dir| echo "peer-$i download model" &
done

wait

output_file="../fig14_output/30pod_ml_preheat_50.txt"
touch ../fig14_output/30pod_ml_preheat_50.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

# ------------------------------------ 100个预热的结果
# 预热够100个

for i in $(seq 60 99);do
  command_preheat $i &
done

wait

tmp_dir=$(mktemp -d)

for i in $(seq 100 110);do
  command $i $tmp_dir| echo "peer-$i download model" &
done

wait

output_file="../fig14_output/30pod_ml_preheat_100.txt"
touch ../fig14_output/30pod_ml_preheat_100.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"
