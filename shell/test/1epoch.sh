#!/bin/bash 

output_file="../test_output/50pod_500M_ml_epoch1.txt"

tmp_dir=$(mktemp -d)

pod="dragonf-ulg1d8-dragonfly-peer"
minio_address=$MINIO_ADDRESS
model="http://210.30.96.107:32055/model/5002.bin"
container="peer"
namespace="d7y"

mkdir -p ../test_output
touch ../test_output/50pod_500M_ml_epoch1.txt

command() {
  kubectl exec -it $pod-$1 -c peer -n $namespace -- dfget -o /test -u $model  >> "$tmp_dir/$1.txt"
}

command_delete() {
  kubectl exec -it $pod-$1 -c peer -n $namespace -- rm -rf /test
}

for i in $(seq 0 1);do
  command $i | echo "peer-$i download model" &
done

wait

cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 0 1);do
 command_delete $i | echo "peer-$i remove model" &
done

wait