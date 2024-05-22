#!/bin/bash 



tmp_dir=$(mktemp -d)

pod="dragonfly-peer"
minio_address=$MINIO_ADDRESS
model="http://$minio_address/models/10G.bin?x=1002"
container="peer"
namespace="dragonfly-system"

mkdir -p ../fig14_output

command() {
  kubectl exec -it $pod-$1 -c peer -n $namespace -- dfget -o /test -u $model  >> "$tmp_dir/$1.txt" &
}

command_delete() {
  kubectl exec -it $pod-$1 -c peer -n $namespace -- rm -rf /test
}

for i in $(seq 0 9);do
  command $i | echo "peer-$i download model"
done

wait

output_file="../fig14_output/10pod_ml_preheat_0.txt"
touch ../fig14_output/10pod_ml_preheat_0.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

# for i in $(seq 0 9);do
#  command_delete $i | echo "peer-$i remove model"
# done