#!/bin/bash 

pod="dragonf-ulg1d8-dragonfly-peer"
minio_address=$MINIO_ADDRESS
container="peer"
namespace="d7y"

mkdir -p ../fig14_output

# ------------------------------------ 没有预热
tmp_dir=$(mktemp -d)
model="http://210.30.96.107:32055/model/5002.bin?x=3213"

for i in $(seq 0 1);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model  >> "$tmp_dir/$i.txt" | echo "peer-$i download model"  &
done

wait

output_file="../fig14_output/test_preheat_0.txt"
touch ../fig14_output/test_preheat_0.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 0 1);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf /test &
done

wait
# ------------------------------------ 2个预热的结果

tmp_dir=$(mktemp -d)

for i in $(seq 2 3);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model  >> "$tmp_dir/$i.txt" | echo "peer-$i download model"  &
done

wait

output_file="../fig14_output/test_preheat_2.txt"
touch ../fig14_output/test_preheat_2.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 2 3);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf /test &
done

wait
# ------------------------------------ 6个预热的结果

for i in $(seq 4 5);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model &
done

wait

tmp_dir=$(mktemp -d)

for i in $(seq 6 7);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model  >> "$tmp_dir/$i.txt" | echo "peer-$i download model"  &
done

wait

output_file="../fig14_output/test_preheat_6.txt"
touch ../fig14_output/test_preheat_6.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 6 7);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf /test &
done

wait
# ------------------------------------ 8个预热的结果

tmp_dir=$(mktemp -d)

for i in $(seq 8 9);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- dfget -o /test -u $model  >> "$tmp_dir/$i.txt" | echo "peer-$i download model"  &
done

wait

output_file="../fig14_output/test_preheat_8.txt"
touch ../fig14_output/test_preheat_8.txt
cat "$tmp_dir"/*.txt > "$output_file"

rm -rf "$tmp_dir"

for i in $(seq 8 9);do
    kubectl exec -it $pod-$i -c peer -n $namespace -- rm -rf /test &
done

wait