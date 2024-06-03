#!/bin/bash 

output_file="../test_output/back_to_source.txt"

tmp_dir=$(mktemp -d)

pod="dragonf-ulg1d8-dragonfly-peer"
minio_address=$MINIO_ADDRESS
model="http://210.30.96.107:32055/model/2001.json"
container="peer"
namespace="d7y"

mkdir -p ../test_output
touch ../test_output/back_to_source.txt

command() {
  start=$(date +%s%3N)
  kubectl exec -it $pod-$1 -c peer -n $namespace -- wget --no-cache $model >> "$tmp_dir/$1.txt"
  end=$(date +%s%3N)
  execution_time=$((end - start))
  echo "$pod-$1 download $model execution time: $execution_time" >> "$tmp_dir/$1.txt"
}

command_delete() {
  kubectl exec -it $pod-$1 -c peer -n $namespace -- rm -rf 2001.json
}

for i in $(seq 8 8);do
  command $i | echo "peer-$i download model" &
done

wait

cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 8 8);do
 command_delete $i | echo "peer-$i remove model" &
done

wait