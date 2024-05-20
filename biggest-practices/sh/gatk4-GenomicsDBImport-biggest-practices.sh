#!/bin/bash
interval=$1
sample_name_map=$2
workspace_dir_name=$3

echo $interval
echo $sample_name_map
echo $workspace_dir_name

gatk --java-options "-Xmx25g -Xms8g" \
  GenomicsDBImport \
  --genomicsdb-workspace-path "$workspace_dir_name" \
  --batch-size 50 \
  -L "$interval" \
  --sample-name-map "$sample_name_map" \
  --reader-threads 5 \
  --merge-input-intervals \
  --consolidate

tar -cf "$workspace_dir_name".tar "$workspace_dir_name"
