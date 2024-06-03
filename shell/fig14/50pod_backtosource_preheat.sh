#!/bin/bash 

pod="dragonfly-peer"
minio_address=$MINIO_ADDRESS
container="peer"
namespace="dragonfly-system"

mkdir -p ../fig14_output

command() {
  start=$(date +%s%3N)
  kubectl exec -it $pod-$1 -c peer -n $namespace -- wget --no-cache $2 >> "$3/$1.txt"
  end=$(date +%s%3N)
  execution_time=$((end - start))
  echo "$pod-$1 download $2 execution time: $execution_time" >> "$3/$1.txt"
}

# 回源预热多少都差不多一致，所以测一次就行。
tmp_dir=$(mktemp -d)
model="http://$minio_address/models/1G.bin?x=1305"

for i in $(seq 0 49);do
    command $i $model $tmp_dir | echo "peer-$i download model" &
done

wait

output_file="../fig14_output/50pod_backtosource_preheat_0.txt"
touch ../fig14_output/50pod_backtosource_preheat_0.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 0 49);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf 1G.bin?x=1305 &
done

wait