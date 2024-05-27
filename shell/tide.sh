#!/bin/bash

output_file="tide.txt"
pod="dragonfly-peer"
minio_address=$MINIO_ADDRESS
model="http://$minio_address/models/500M.bin"
namespace="dragonfly-system"
type=10 #通过改变url后缀的方式，模拟任务的种类
sum_pod=1000 # 1000
tide_fall_pod=20 # 1000/50=20 每次循环执行任务的pod 潮落
tide_rise_pod=200 # 1000/5=200 每次循环执行任务的pod 潮涨
tide_fall_epoch=20 # 20分钟 
tide_rise_epoch=40 # 40分钟
sleep_time=60 # 60s

rm tide.txt
touch tide.txt

command() {
  kubectl exec -it $pod-$2 -c peer -n $namespace -- dfget -o /test -u $model?x=$3 >> "$1/$2.txt"
}

command_delete() {
  kubectl exec -it $pod-$1 -c peer -n $namespace -- rm -rf /test
}

# 模拟潮落,晚上00：00~早上8：00 8个小时，占24小时的三分之一，映射到一个小时上就是20分钟
function tide_fall() {
    # 第一个for循环结合sleep 来控制潮落持续时间和间隔。模拟潮落20分钟，
    for ((i=0; i<$tide_fall_epoch; i++)); do
        echo "tide fall epoch $i"
        tmp_dir=$(mktemp -d)
        # 该随机是随机pod执行拉取任务，潮落时候限制小一些范围
        # 真实场景下10w个节点大约有2k左右的并发任务，比例是50个节点有一个并发任务，1000个节点每次执行20个任务
        # 该for循环是指定随机的50个pod执行拉取任务
        for ((j=0; j<$tide_fall_pod; j++)); do
	       numbers[$j]=$((RANDOM % $sum_pod))
	       types[$j]=$((RANDOM % $type))
	   done
	   # 需要加上一个参数，随机下载的内容不一致。
	   for ((j=0; j<$tide_fall_pod; j++)) do
		  command "$tmp_dir" "${numbers[$j]}" "${types[$j]}" | echo "peer-${numbers[$j]} download ${types[$j]} model" &
	   done
	   wait
	   cat "$tmp_dir"/*.txt >> "$output_file"
        rm -rf "$tmp_dir"
	   for number in "${numbers[@]}"; do
		   command_delete "$number" | echo "peer-$number remove model" &
	   done
        sleep $sleep_time
    done
}

# 模拟潮涨,早上8：00~晚上00：00 16个小时，占24小时的三分之二，映射到一个小时上就是40分钟
function tide_rise() {
    # 第一个for循环结合sleep 来控制潮涨持续时间和间隔。
    for ((i=0; i<$tide_rise_epoch; i++)); do
        echo "tide rise epoch $i"
        tmp_dir=$(mktemp -d)
        # 该随机是随机几个pod执行拉取任务，潮涨时候限制大一些范围
        # 真实场景下10w个节点大约有20k左右的并发任务，比例是5个节点有一个并发任务，1000个节点每次执行200个任务
        # 该for循环是指定随机的200个pod执行拉取任务
        for ((j=0; j<$tide_rise_pod; j++)); do
	       numbers[$j]=$((RANDOM % $sum_pod))
	       types[$j]=$((RANDOM % $type))
	   done
	   # 需要加上一个参数，随机下载的内容不一致。
	   for ((j=0; j<$tide_rise_pod; j++)); do
		  command "$tmp_dir" "${numbers[$j]}" "${types[$j]}" | echo "peer-${numbers[$j]} download ${types[$j]} model" &
	   done
	   wait
	   cat "$tmp_dir"/*.txt >> "$output_file" 
        rm -rf "$tmp_dir"
	   for number in "${numbers[@]}"; do
		   command_delete "$number" | echo "peer-$number remove model" &
	   done
        sleep $sleep_time
    done
}

count=0 # 设定跳出标志,几次潮起潮落。
while true; do
    tide_fall
    tide_rise
    ((count++))
    if [ $count -eq 1 ];then # 1个小时
      break
    fi
done