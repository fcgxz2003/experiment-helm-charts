#!/bin/bash 

output_file="../fig11_output/50pod_1G_backtosource_epoch3.txt"

tmp_dir=$(mktemp -d)

pod="dragonfly-peer"
minio_address=$MINIO_ADDRESS
model="http://$minio_address/models/1G.bin?x=1003"
container="peer"
namespace="dragonfly-system"

mkdir -p ../fig11_output
touch ../fig11_output/50pod_1G_backtosource_epoch3.txt

command() {
  start=$(date +%s%3N)
  kubectl exec -it $pod-$1 -c peer -n $namespace -- wget --no-cache $model >> "$tmp_dir/$1.txt"
  end=$(date +%s%3N)
  execution_time=$((end - start))
  echo "$pod-$1 download $model execution time: $execution_time" >> "$tmp_dir/$1.txt"
}

command_delete() {
  kubectl exec -it $pod-$1 -c peer -n $namespace -- rm -rf 1G.bin?x=1003
}

for i in $(seq 100 149);do
  command $i | echo "peer-$i download model" &
done

wait

cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 100 149);do
 command_delete $i | echo "peer-$i remove model" &
done

wait