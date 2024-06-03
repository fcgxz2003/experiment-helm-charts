#!/bin/bash 

output_file="../fig12_output/10pod_500M_random.txt"

tmp_dir=$(mktemp -d)

pod="dragonfly-peer"
minio_address=$MINIO_ADDRESS
model="http://$minio_address/models/500M.bin?x=1002"
container="peer"
namespace="dragonfly-system"

mkdir -p ../fig12_output
touch ../fig12_output/10pod_500M_random.txt

command() {
  kubectl exec -it $pod-$1 -c peer -n $namespace -- dfget -u $model  >> "$tmp_dir/$1.txt"
}

command_delete() {
  kubectl exec -it $pod-$1 -c peer -n $namespace -- rm -rf 500M.bin?x=1002
}

for i in $(seq 380 389);do
  command $i | echo "peer-$i download model" &
done

wait

cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 380 389);do
 command_delete $i | echo "peer-$i remove model" &
done

wait